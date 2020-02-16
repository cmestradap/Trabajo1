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
        return getLocalNames(resultSet, "?class");
    }
    
    public Collection<String> getDataAttributes(String entity) {
        ResultSet resultSet = execQuery("PREFIX f: <http://www.futbolistas.com#>\nPREFIX owl: <http://www.w3.org/2002/07/owl#>\nPREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\nSELECT DISTINCT ?prop WHERE { ?prop a owl:DatatypeProperty. ?prop rdfs:domain f:" + entity + ". }");
        return getLocalNames(resultSet, "?prop");
    }
    
    private ResultSet execQuery(String queryStr)
    {
        Query query = QueryFactory.create(queryStr);
        QueryExecution qexec = QueryExecutionFactory.create(query, m_model);
        return qexec.execSelect();
    }
    
    private Collection<String> getLocalNames(ResultSet resultSet, String node) {
        ArrayList<String> entities = new ArrayList<>();
        while (resultSet.hasNext())
        {
          QuerySolution solution = resultSet.next();
          entities.add(solution.get(node).asNode().getLocalName());
        }
        return entities;
    }
}
