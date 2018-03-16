<aura:application extends="force:slds" >
    <c:ETLC_PleaseWait />
    <c:ETLC_ApexBridge aura:id="ApexBridge" />
    
    <aura:attribute name="yourName" type="String" />

    <div class="slds-m-around_xx-large">
        <lightning:button label="Apex, are you there?" onclick="{!c.areYouThere}" variant="brand" />
    </div>
    <hr/>
    <div  class="slds-m-around_xx-large">
        <div class="slds-form_inline">
            <lightning:input label="What's your name?" name="yourName" value="{!v.yourName}" />
            <lightning:button label="Say Hi" onclick="{!c.greet}" disabled="{!empty(v.yourName)}" variant="brand"  />
        </div>
    </div>
</aura:application>