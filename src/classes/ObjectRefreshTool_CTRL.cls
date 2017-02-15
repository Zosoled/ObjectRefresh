/**
 * src/classes/ObjectRefreshTool_CTRL.cls
 *
 * The controller for the ObjectRefreshTool Visualforcepage.
 */
public class ObjectRefreshTool_CTRL {
  public BatchJob batchJob {get; set;}
  public ObjectRefreshTool_CTRL() {
    batchJob = new BatchJob();
  }
}