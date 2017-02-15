/**
 * src/classes/ObjectRefresh_BATCH.cls
 *
 * The batchable class that is executed from the ObjectRefresh controller.
 */
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
      throw new ObjectRefreshBatch_Exception('Error when querying records.', e);
    }
    return records;
  }
  
  global void execute(Database.BatchableContext bc, sObject[] records) {
    Database.SaveResult[] results = new Database.SaveResult[]{};
    if (records != null) {
      try {
      	results = Database.update(records);
      } catch (Exception e) {
        throw new ObjectRefreshBatch_Exception('Error when querying records.', e);
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