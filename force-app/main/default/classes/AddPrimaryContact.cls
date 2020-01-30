
public with sharing class AddPrimaryContact implements Queueable {
    Contact c = new Contact();
    String usState;
    public AddPrimaryContact(Contact x, String y) {
        c = x;
        usState = y;
    }

    public void execute(QueueableContext context) {
        List<Contact> cons = new List<Contact>();
        List<Account> accts = [SELECT Id FROM Account WHERE BillingState = :usState LIMIT 200];
        for (Account a : accts){
            Contact con = c.clone();
            con.AccountId = a.Id;
            cons.add(con);
            //c.clone()sfdx 
        }
        insert cons;

    }
}
