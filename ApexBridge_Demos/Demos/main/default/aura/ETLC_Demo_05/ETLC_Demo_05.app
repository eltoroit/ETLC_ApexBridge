<aura:application extends="force:slds">
    <c:ETLC_ApexBridge aura:id="ETLC_ApexBridge" />
    
    <div class="slds-m-around--xx-large">
        <lightning:button label="Create Accounts" onclick="{!c.createAccounts}"
                          variant="brand" />
    </div>
</aura:application>