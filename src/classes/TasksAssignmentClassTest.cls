@isTest(SeeAllData=false)
public class TasksAssignmentClassTest {
     static testMethod void reassignRecords2NewUsers() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User saUser = new User (
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='standardSA_User@testorg.com',
            Sales_Associate_Number__c = '19860'
        );
        insert saUser;
            
        Account acc1 = new Account (
            Name = 'testAccount1',
            Sales_Associate_Number__c = '19860'
        );
        insert acc1;
         
        Account acc2 = new Account (
            Name = 'testAccount2',
            Sales_Associate_Number__c = '00000'
        );
        insert acc2;
         
        List<Task> tasks = new List<Task>();
         
        Task t1 = new Task (
            Subject = 'task1',
            WhatId = acc1.Id
        );
        insert t1;
        tasks.add(t1);
         
        Task t2 = new Task (
            Subject = 'task2',
            WhatId = acc2.Id
        );
        insert t2;
        tasks.add(t2);
        
        Test.startTest();    
        
        TasksAssignmentClass.reassignRecords2NewUsers(tasks);
        Task task1Result = [SELECT OwnerId FROM Task WHERE Id = : t1.Id];
        system.debug('task1Result'+task1Result);
        Task task2Result = [SELECT OwnerId FROM Task WHERE Id = : t2.Id];
        system.debug('task2Result'+task2Result);
         
        system.debug('saUser'+saUser);
         
        system.assertEquals(task1Result.OwnerId, saUser.id);
        system.assertNotEquals(task2Result.OwnerId, saUser.id);
        Test.stopTest();
        
     }
}