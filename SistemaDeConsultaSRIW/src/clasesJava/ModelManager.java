/**
 *
 * @author lummoralz
 */
package clasesJava;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import org.apache.jena.query.*;
import org.apache.jena.rdf.model.InfModel;

import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.util.FileManager;
import org.apache.jena.reasoner.Reasoner;
import org.apache.jena.reasoner.ReasonerRegistry;
import org.apache.jena.reasoner.ValidityReport;

public class ModelManager {
    private final Model m_model;
    private final Reasoner m_owlReasoner;
    private final InfModel m_owlInfe;

    public ModelManager(String file) throws Exception {
        m_model = ModelFactory.createDefaultModel();
        InputStream in = FileManager.get().open(file);
        m_model.read(in, null, "RDF/XML");
        
        m_owlReasoner = ReasonerRegistry.getOWLReasoner();
        m_owlInfe = ModelFactory.createInfModel(m_owlReasoner, m_model);
        
        ValidityReport validity = m_owlInfe.validate();
         if (!validity.isValid()) {
            String err = "Errors: \n";
            for (Iterator i = validity.getReports(); i.hasNext();)
              err += " - " + i.next() + "\n";
            
            throw new Exception(err);
        }
    }

    public Collection<String> getEntities() {
        ResultSet resultSet = execQuery("PREFIX owl: <http://www.w3.org/2002/07/owl#>\nSELECT DISTINCT ?class WHERE { ?class a owl:Class. FILTER(?class != owl:Thing) }");
        return getNodeNames(resultSet, "?class");
    }
    
    public Collection<String> getDataAttributes(String entity) {
        String query = "PREFIX f: <http://www.futbolistas.com#>\nPREFIX owl: <http://www.w3.org/2002/07/owl#>\nPREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\nSELECT DISTINCT ?prop WHERE { ?prop a owl:DatatypeProperty. ?prop rdfs:domain f:" + entity + ". }";
        ResultSet resultSet = execQuery(query);
        return getNodeNames(resultSet, "?prop");
    }
    
    public Collection<String> getInstances(String entity) {
        String query = "PREFIX f: <http://www.futbolistas.com#>\nSELECT ?obj WHERE { ?obj a f:" + entity + ". } ORDER BY ?obj";
        ResultSet resultSet = execQuery(query);
        return getResourceNames(resultSet, "?obj");
    }
    
    public Object[][] getAttributeValues(String entity, Collection<String> attributes)
    {
        String query = "PREFIX f: <http://www.futbolistas.com#>\nSELECT ?obj";
        for (int i = 0; i < attributes.size(); ++i) {
            query += " ?attr" + i;
        }
        query += " WHERE { ?obj a f:" + entity;
        
        Integer i = 0;
        for (String attr : attributes) {
            query += ". ?obj f:" + attr + " ?attr" + i++;
        }
        query += ".}";
        i = 0;
        ResultSet resultSet = execQuery(query);
        ArrayList<Object[]> result = new ArrayList<>();
        while (resultSet.hasNext()) {
            QuerySolution solution = resultSet.next();
            Object[] row = new Object[attributes.size() + 1];
            for (i = 0; i < attributes.size(); ++i) {
                row[i] = solution.get("?attr" + i).asLiteral().getValue();
            }
            row[attributes.size()] = solution.get("?obj").asResource().getLocalName();
            result.add(row);
        }
        return convert(result);
    }
    
    public Object[][] getInstancesIndirect(String entity) {
        String query = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\nPREFIX f: <http://www.futbolistas.com#>\nSELECT DISTINCT ?obj ?name WHERE { ?obj a ?class. ?obj f:Name ?name. { ?class rdfs:subClassOf f:" + entity + ". } UNION { ?obj a f:" + entity + " }.}";
        ResultSet resultSet = execQuery(query);
        ArrayList<Object[]> result = new ArrayList<>();
        while (resultSet.hasNext()) {
            QuerySolution solution = resultSet.next();
            result.add(new Object[] { solution.get("?name").asLiteral().getValue() });
        }
        return convert(result);
    }
    
    public Collection<String> getSameAs(String instance) {
        String query = "PREFIX f: <http://www.futbolistas.com#>\nPREFIX owl: <http://www.w3.org/2002/07/owl#>\nSELECT DISTINCT ?other WHERE {?obj a owl:NamedIndividual. ?obj owl:sameAs ?other. FILTER(?obj = f:" + instance + ") }";
        ResultSet resultSet = execQuery(query);
        return getResourceNames(resultSet, "?other");
    }
    
    public Object[][] getRelations(String instance) {
        String query = "PREFIX f: <http://www.futbolistas.com#>\nPREFIX owl: <http://www.w3.org/2002/07/owl#>\nSELECT DISTINCT ?rel ?val WHERE {?obj a owl:NamedIndividual.?obj ?rel ?val.?rel a owl:ObjectProperty. FILTER(?obj = f:" + instance + ") }";
        ResultSet resultSet = execQuery(query);
        ArrayList<Object[]> result = new ArrayList<>();
        while (resultSet.hasNext()) {
            QuerySolution solution = resultSet.next();
            result.add(new Object[] { solution.get("?rel").asResource().getLocalName(), solution.get("?val").asResource().getLocalName() });
        }
        return convert(result);
    }
    
    public Object[][] getSameAttributeAs(String entity, String attribute, String value) {
        String query = "PREFIX f: <http://www.futbolistas.com#>\nSELECT DISTINCT ?name ?val WHERE { ?obj a f:" + entity + ". ?obj f:" + attribute + " ?val. ?obj f:Name ?name. FILTER(STR(?val) = '" + value + "')}";
        ResultSet resultSet = execQuery(query);
        ArrayList<Object[]> result = new ArrayList<>();
        while (resultSet.hasNext()) {
            QuerySolution solution = resultSet.next();
            result.add(new Object[] { solution.get("?name").asLiteral().getValue(), solution.get("?val").asLiteral().getValue() });
        }
        return convert(result);
    }
    
    private Object[][] convert(ArrayList<Object[]> result) {
        Integer i = 0;
        Object[][] data = new Object[result.size()][];
        for (Object[] row : result) {
            data[i++] = row;
        }
        return data;
    }
    
    private ResultSet execQuery(String queryStr)
    {
        System.out.println(queryStr);
        Query query = QueryFactory.create(queryStr);
        QueryExecution qexec = QueryExecutionFactory.create(query, m_model);
        return qexec.execSelect();
    }
    
    private Collection<String> getNodeNames(ResultSet resultSet, String node) {
        ArrayList<String> entities = new ArrayList<>();
        while (resultSet.hasNext())
        {
          QuerySolution solution = resultSet.next();
          entities.add(solution.get(node).asNode().getLocalName());
        }
        return entities;
    }
    
    private Collection<String> getResourceNames(ResultSet resultSet, String node) {
        ArrayList<String> entities = new ArrayList<>();
        while (resultSet.hasNext())
        {
          QuerySolution solution = resultSet.next();
          entities.add(solution.get(node).asResource().getLocalName());
        }
        return entities;
    }
}