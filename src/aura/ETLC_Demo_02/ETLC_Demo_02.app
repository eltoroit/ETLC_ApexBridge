<aura:application extends="force:slds" >
    <c:ETLC_ApexBridge aura:id="ApexBridge" />
    
    <aura:attribute name="demoTopic" type="String" />
    <aura:attribute name="demoWhen" type="DateTime" />
    <aura:attribute name="demoDuration" type="Integer" default="30" />
    
    <aura:handler name="init" value="{!this}" action="{!c.doInit}" />
    
    <div class="slds-m-around--xx-large">
        <div class="slds-text-heading--medium">Schedule Demo</div>
        <table>
            <tr>
                <td colspan="2">
                    <lightning:input label="Topic" name="demoTopic"
                                     type="text" value="{!v.demoTopic}" />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <ui:inputDateTime aura:id="demoWhen" label="When"
                                      requiredIndicatorClass="slds-required"
                                      class="slds-form-element__control slds-input fullWidth"
                                      value="{!v.demoWhen}" displayDatePicker="true" />
                </td>
            </tr>
            <tr>
                <td colspan="2" width="50%" style="position: relative;">
                    <lightning:input label="Duration" name="demoDuration"
                                     type="range" min="5" max="360" step="5"
                                     value="{!v.demoDuration}" />
                    <span style="position: absolute; bottom: -10px; right: 0;">
                        ({!v.demoDuration} minutes)
                    </span>
                </td>
            </tr>
        </table>
        <div class="slds-m-around--xx-large">
            <lightning:button label="Remindme" onclick="{!c.createMeeting}"
                              class="fullWidth" variant="brand"  />
        </div>
    </div>
</aura:application>