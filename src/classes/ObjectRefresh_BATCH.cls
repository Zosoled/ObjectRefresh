global class ObjectRefresh_BATCH implements Database.Batchable<sObject>, Database.Stateful {
  private String obj;
  public Database.SaveResult[] dsr;
  
  public class ObjectRefreshBatch_Exception extends Exception {}
  
  global ObjectRefresh_BATCH(String o) {
    if (String.isBlank(o)) {
      throw new ObjectRefreshBatch_Exception('Provide an object to process.');
    } else {
    	this.obj = o;
    	this.dsr = new Database.SaveResult[]{};
    }
  }
  
  global Iterable<sObject> start(Database.BatchableContext bc) {
    String q = 'select Id from ';
    q += String.escapeSingleQuotes(obj);
    sObject[] records = new sObject[]{};
    try {
    	records = Database.query(q);
    } catch (Exception e) {
      System.debug(e.getMessage());
      System.debug(e.getLineNumber());
      System.debug(e.getCause());
      System.debug(e.getStackTraceString());
    }
    return records;
  }
  
  global void execute(Database.BatchableContext bc, sObject[] records) {
    Database.SaveResult[] results = new Database.SaveResult[]{};
    if (records != null) {
      try {
      	results = Database.update(records);
      } catch (Exception e) {
        System.debug(e.getMessage());
        System.debug(e.getLineNumber());
        System.debug(e.getCause());
        System.debug(e.getStackTraceString());
      }
    }
    dsr.addAll(results);
  }
  
  global void finish(Database.BatchableContext bc) {
    System.debug('ObjectRefreshBatch finished with these results:');
    for (Database.SaveResult sr : dsr) {
    	System.debug(sr);
    }
  }
}