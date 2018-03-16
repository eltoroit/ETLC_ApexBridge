<aura:application extends="force:slds">
    <c:ETLC_ApexBridge aura:id="ApexBridge" />
    <aura:attribute name="accounts" type="Account[]" access="private" />
    <aura:handler name="init" value="{!this}" action="{!c.doInit}" />
    <div  class="slds-m-around_xx-large">
        <table class="slds-table slds-table_bordered slds-table_cell-buffer">
            <thead>
                <tr class="slds-text-title_caps">
                    <th style="width:50%">
                        Name
                    </th>
                    <th>
                        Last Modified
                    </th>
                </tr>
            </thead>
            <tbody>
                <aura:iteration aura:id="loop" items="{!v.accounts}" var="acc">
                    <tr>
                        <td>
                            <ui:inputText value="{!acc.Name}" required="true"
                                          class="myTextBox"/>
                        </td>
                        <td>
                            {!acc.LastModifiedDate}
                        </td>
                    </tr> 
                </aura:iteration>
            </tbody>
        </table>
        <div class="slds-m-horizontal_xx-large slds-m-vertical_x-small">
            <lightning:button label="Save Accounts" onclick="{!c.saveAccounts}" variant="brand" class="myButton" />
        </div>
    </div>
</aura:application>