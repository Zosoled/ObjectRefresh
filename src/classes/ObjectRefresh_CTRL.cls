/**
 * src/classes/ObjectRefresh_CTRL.cls
 *
 * The controller for the ObjectRefresh component.
 */
public class ObjectRefresh_CTRL {
  public String selectedObject {get; set;}
  public List<SelectOption> objects {get; set;}
  public BatchJob batchJob {get; set;}
  public Boolean ready {get; set;}
  
  public class ObjectRefreshCtrl_Exception extends Exception {}
  
  public ObjectRefresh_CTRL() {
    ready = true;
    selectedObject = 'test';
    objects = new List<SelectOption>();
    
    try {
      Map<String, Schema.SObjectType> results = Schema.getGlobalDescribe();
      for (String s : results.keyset()) {
        DescribeSObjectResult o = results.get(s).getDescribe();
        if (o.isUpdateable()) {
          objects.add(new SelectOption(o.getName(), o.getLabel()));
        }
      }
    } catch (Exception e) {
      System.debug(e.getLineNumber());
      System.debug(e.getMessage());
      System.debug(e.getCause());
      System.debug(e.getStackTraceString());
      ApexPages.addMessages(e);
    }
    
    objects.sort();
  }
  
  public void submit() {
    if (String.isBlank(selectedObject)) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Select an object'));
    } else {
      try {
        ObjectRefresh_BATCH orb = new ObjectRefresh_BATCH(selectedObject);
        batchJob.Id = Database.executeBatch(orb);
      } catch (Exception e) {
        System.debug(e.getLineNumber());
        System.debug(e.getMessage());
        System.debug(e.getCause());
        System.debug(e.getStackTraceString());
        ApexPages.addMessages(e);
      }
    }
  }
  
  public void cancel() {
    if (batchJob.Id != null) {
      System.abortJob(batchJob.Id);
    }
  }
  
  public void reset() {
    if (batchJob.Id != null) {
      batchJob.Id = null;
    }
  }
}