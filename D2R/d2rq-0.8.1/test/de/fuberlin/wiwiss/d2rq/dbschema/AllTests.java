package de.fuberlin.wiwiss.d2rq.dbschema;

import junit.framework.Test;
import junit.framework.TestSuite;

public class AllTests {

	public static Test suite() {
		TestSuite suite = new TestSuite(
				"Test for de.fuberlin.wiwiss.d2rq.dbschema");
		//$JUnit-BEGIN$
		suite.addTestSuite(ISWCSchemaTest.class);
		//$JUnit-END$
		return suite;
	}

}
