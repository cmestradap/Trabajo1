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
    
    @Override
    public String toString() {
        String attr = "?" + m_attribute;
        switch(m_operator) {
            case "Igual": {
                String value = m_value.trim();
                if (!isNumeric(value)) {
                    value = "'" + value + "'";
                }
                return attr + "=" + value;
            }
            case "Contiene": return "regex(str(" + attr + "), \"" + m_value + "\")";
            case "Mayor que": return attr + ">" + m_value;
            case "Mayor o igual": return attr + ">=" + m_value;
            case "Menor que": return attr + "<" + m_value;
            case "Menor o igual": return attr + "<=" + m_value;
        }
        return "";
    }
    
    private static boolean isNumeric(String strNum) {
        if (strNum == null) {
            return false;
        }
        try {
            double d = Double.parseDouble(strNum);
        } catch (NumberFormatException nfe) {
            return false;
        }
        return true;
    }
}