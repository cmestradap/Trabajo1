package clasesJava;

/**
 *
 * @author lummoralz
 */
public class FilterItem {
    private final String m_attribute, m_operator, m_value;
    
    public FilterItem(String a, String o, String v) {
        m_attribute = a;
        m_operator = o;
        m_value = v;
    }
    
    public final String getAttribute() {
        return m_attribute;
    }
    
    public final String getOperator() {
        return m_operator;
    }
    
    public final String getValue() {
        return m_value;
    }
    
    public final Boolean isComplete() {
        return (m_attribute != null && m_attribute != "") && (m_operator != null && m_operator != "") && (m_value != null && m_value != "");
    }
        
    public String toString(int index) {
        String attr = "?attr" + index;
        switch(m_operator) {
            case "Igual": return "str(" + attr + ")='" + m_value + "'";
            case "Contiene": return "regex(str(" + attr + "), \"" + m_value + "\")";
            case "Mayor que": return attr + ">" + m_value;
            case "Mayor o igual": return attr + ">=" + m_value;
            case "Menor que": return attr + "<" + m_value;
            case "Menor o igual": return attr + "<=" + m_value;
        }
        return "";
    }
}