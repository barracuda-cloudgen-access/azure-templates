# Documentation:
#  - Test Parameters: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/test-toolkit#test-parameters
#  - Test Cases: https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/test-cases
@{
    Test = @(
        'adminUsername Should Not Be A Literal',
        'Allowed Values Should Actually Be Allowed',
        'artifacts parameter',
        'CommandToExecute Must Use ProtectedSettings For Secrets',
        'Controls In Outputs Must Exist',
        'CreateUIDefinition Should Have Schema',
        'CreateUIDefinition',
        'DependsOn Must Not Be Conditional',
        'Deployment Resources Must Not Be Debug',
        'DeploymentTemplate Must Not Contain Hardcoded Uri',
        'Dynamic Variable References Should Not Use Concat',
        'Handler Must Be Correct',
        'HideExisting Must Be Correctly Handled',
        'IDs Should Be Derived From ResourceIDs',
        'JSONFiles Should Be Valid',
        'lidating barracuda-cga-proxy-cga-proxy-01\mainTemplate.json',
        'Location Should Not Be Hardcoded',
        'ManagedIdentityExtension must not be used',
        'Min And Max Value Are Numbers',
        'Outputs Must Be Present In Template Parameters',
        'Outputs Must Not Contain Secrets',
        'Parameter Types Should Be Consistent',
        'Parameters Must Be Referenced',
        'Parameters Property Must Exist',
        'Parameters Without Default Must Exist In CreateUIDefinition',
        'Password params must be secure',
        'Password Textboxes Must Be Used For Password Parameters',
        'PasswordBoxes Must Have Min Length',
        'Providers apiVersions Is Not Permitted',
        'ResourceIds should not contain',
        'Resources Should Have Location',
        'Resources Should Not Be Ambiguous',
        'Secure Params In Nested Deployments',
        'Secure String Parameters Cannot Have Default',
        'Usernames Should Not Have A Default',
        'Validations Must Have Message',
        'Variables Must Be Referenced',
        'Virtual Machines Should Not Be Preview',
        'VM Images Should Use Latest Version',
        'VM Size Should Be A Parameter',
        'VMSizes Must Match Template'
        )
    Skip = @(
        # We are not hardcoding, there is a parameter to set the location value
        'Location Should Not Be Hardcoded',
        'CreateUIDefinition Must Not Have Blanks',
        'Outputs Must Be Present In Template Parameters'
    )
}
