/**
 * Copyright (c) 2012, Salesforce.com Foundation
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted
 * provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this list of conditions
 *    and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice, this list of
 *    conditions and the following disclaimer in the documentation and/or other materials provided
 *    with the distribution.
 * 3. Neither the name of the Salesforce.com Foundation nor the names of its contributors may be
 *    used to endorse or promote products derived from this software without specific prior written
 *    permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 * WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * @author Salesforce.com Foundation
 * @date 2012 (2.0)
 * @group Utilities
 * @description The controller for the VF progress indicator component.
 * @modified Chris Duncan 2017
 */
public with sharing class JobProgress_CTRL {
  public Id batchJobId {get; set;}
  public Boolean processing {get; set;}
  public Boolean hasExtendedStatus {get; set;}
  public Integer percentComplete {get; set;}
  
  public String componentLabel {
    get {return (componentLabel==null) ? 'Batch Apex Job Progress' : componentLabel;}
    set;
  }
  
  public AsyncApexJob batchJob {
    get {
      List<AsyncApexJob> batchJobs = [
        select Id, TotalJobItems, Status, ExtendedStatus, NumberOfErrors, MethodName, JobType,
            JobItemsProcessed, CompletedDate, ApexClassId, ApexClass.Name, CreatedDate, CreatedById,
            CreatedBy.Name
        from AsyncApexJob
        where Id = :batchJobId
        order by CreatedDate
        limit 1
      ];
      
      if (batchJobs.isEmpty()) return null;
      
      processing = true;
      AsyncApexJob batchJob = batchJobs[0];
      Double batchesProcessed = batchJob.JobItemsProcessed;
      Double totalBatches = batchJob.TotalJobItems;
      hasExtendedStatus = String.isNotBlank(batchJob.ExtendedStatus);
      percentComplete = 0;
      
      /* Determine the pecent complete based on the number of batches complete */
      if (batchJob.Status == 'Completed') {
        percentComplete = 100;
        processing = false;
      } else if (totalBatches != 0) {
        percentComplete = ((batchesProcessed / totalBatches) * 100.0).intValue();
      }
      
      return batchJob;
    }
  }
  
  public JobProgress_CTRL() {
    processing = false;
    percentComplete = 0;
    hasExtendedStatus = false;
  }
}