@isTest
private with sharing class AddPrimaryContactTest {
    @TestSetup
    private static void makeData(){
        List<Account> acctsNY = new List<Account>();
        List<Account> acctsCA = new List<Account>();
        for(Integer i = 1; i <= 50; i++){
            Account a = new Account(Name = 'Test Account ' + i, BillingState = 'NY');
            acctsNY.add(a);
            Account b = new Account(Name = 'Test Account ' + i, BillingState = 'CA');
            acctsCA.add(b);
        }
        List<Account> accts = new List<Account>();
        for (Account ny : acctsNY){
            accts.add(ny);
        }
        for (Account ca : acctsCA){
            accts.add(ca);
        }
        insert accts;
    }
    @isTest
    private static void testCloneContactsToAllAccountsInState(){
        //create a contact to use for the constructor
        Contact c = new Contact(LastName = 'Fieri');
        //create the instance for the job to run on
        AddPrimaryContact apc = new AddPrimaryContact(c, 'CA');
        //queue the job
        Test.startTest();
        System.enqueueJob(apc);
        Test.stopTest();
        //Check results
        List<Contact> conCA = [SELECT Id, LastName, AccountId, Account.BillingState FROM Contact 
                                WHERE LastName = 'Fieri'
                                AND Account.BillingState = 'CA'];
        System.assert(conCA.size() == 50);
        List<Contact> conNY = [SELECT Id, LastName, AccountId, Account.BillingState FROM Contact 
                                WHERE LastName = 'Fieri'
                                AND Account.BillingState = 'NY'];
        System.assert(conNY.size() == 0);
    }
}
