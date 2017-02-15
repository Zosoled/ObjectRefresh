/**
 * src/classes/ObjectRefresh_TEST.cls
 *
 * Tests for the ObjectRefresh controller and batch execution.
 */
@isTest
private class ObjectRefresh_TEST {
  
  @testSetup
  static void testSetup() {
    List<Account> listAccount = new List<Account>();
    for (Integer i=0; i<100; i++) {
      String n = 'Test Account ' + i;
      Account a = new Account(Name = n);
      listAccount.add(a);
    }
    insert listAccount;
  }
  
  @isTest
  static void testCtr() {
    Test.startTest();
    ObjectRefresh_CTRL ctrl = new ObjectRefresh_CTRL();
    System.assertEquals('', ctrl.selectedObject);
    System.assertNotEquals(null, ctrl.objects);
    
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    for (SelectOption so : ctrl.objects) {
      String s = so.getValue();
      System.assert(gd.containsKey(s));
    }
    Test.stopTest();
  }
  
  @isTest
  static void testSubmit() {
    ObjectRefresh_CTRL ctrl = new ObjectRefresh_CTRL();
    Test.startTest();
    
    ctrl.submit();
    System.assertEquals(null, ctrl.batchId);
    
    ctrl.selectedObject = 'Account';
    ctrl.submit();
    Test.stopTest();
    System.assertNotEquals(null, ctrl.batchId);
  }
  
  @isTest
  static void testCancel() {
    
  }
  
  @isTest
  static void testBatch() {
    
  }
}