<aura:application >
    <ltng:require styles="{!$Resource.ETLC_SLDS + '/assets/styles/salesforce-lightning-design-system-ltng.css'}"/>
    <c:ETLC_PleaseWait sldsRoot="{!$Resource.ETLC_SLDS}" />
    <aura:handler name="accountChanged" event="c:AccountChanged" action="{!c.accountChanged}"/>
    
    <aura:attribute name="accountSelected" type="Id" />
    <c:AccountList />
    <c:contactGrid accountId="{!v.accountSelected}" />
</aura:application>