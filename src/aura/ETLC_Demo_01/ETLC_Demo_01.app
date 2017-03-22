<aura:application extends="force:slds" >
    <c:ETLC_ApexBridge aura:id="ApexBridge" />
    <aura:attribute name="yourName" type="String" />
    <div class="slds-m-around--xx-large">
        <lightning:button label="Apex, are you there?" onclick="{!c.areYouThere}" variant="brand" />
    </div>
    <hr/>
    <div  class="slds-m-around--xx-large">
        <div class="slds-form--inline">
            <lightning:input label="What's your name?" name="yourName" value="{!v.yourName}" />
            <lightning:button label="Say Hi" onclick="{!c.greet}" disabled="{!empty(v.yourName)}" variant="brand"  />
        </div>
    </div>
</aura:application>