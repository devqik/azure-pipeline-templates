# Azure DevOps Templates for Java, Angular, and NuGet Projects

This repository contains reusable Azure DevOps pipeline templates for Java, Angular, and NuGet (.NET) projects. These templates follow DRY (Don't Repeat Yourself) principles and provide standardized CI/CD pipelines across your organization.

## Repository Structure

```
/templates/
├── jobs/
│   ├── java-build-job.yml          # Java build job (Maven/Gradle)
│   ├── java-test-job.yml           # Java testing job
│   ├── angular-build-job.yml       # Angular build job
│   ├── angular-test-job.yml        # Angular testing job
│   ├── angular-lint-job.yml        # Angular lint job
│   ├── nuget-build-job.yml         # NuGet/.NET build and pack job
│   ├── nuget-test-job.yml          # NuGet/.NET testing job
│   └── nuget-lint-job.yml          # NuGet/.NET lint job (dotnet format)
├── stages/
│   ├── java-ci-stage.yml           # Complete Java CI stage
│   ├── angular-ci-stage.yml        # Complete Angular CI stage
│   └── nuget-ci-stage.yml          # Complete NuGet/.NET CI stage
├── steps/
│   ├── setup-java.yml              # Java environment setup
│   ├── setup-nodejs.yml            # Node.js environment setup
│   ├── setup-dotnet.yml            # .NET SDK environment setup
│   ├── java-build-steps.yml        # Java build steps
│   ├── java-test-steps.yml         # Java test steps
│   ├── angular-build-steps.yml     # Angular build steps
│   ├── angular-test-steps.yml      # Angular test steps
│   ├── nuget-build-steps.yml       # NuGet restore, build, and pack steps
│   ├── nuget-test-steps.yml        # NuGet test steps
│   ├── nuget-lint-steps.yml        # NuGet lint steps (dotnet format)
│   ├── nuget-push-steps.yml        # Push .nupkg files to a feed
│   ├── publish-artifacts.yml       # Artifact publishing
│   └── publish-test-results.yml    # Test results publishing
├── variables/
│   ├── common-variables.yml        # Organization-wide variables
│   ├── java-variables.yml          # Java-specific variables
│   ├── angular-variables.yml       # Angular-specific variables
│   └── nuget-variables.yml         # NuGet/.NET-specific variables
├── examples/
│   ├── java-maven-pipeline.yml     # Example Maven pipeline
│   ├── java-gradle-pipeline.yml    # Example Gradle pipeline
│   ├── angular-pipeline.yml        # Example Angular pipeline
│   ├── nuget-pipeline.yml          # Example NuGet/.NET pipeline
│   └── multi-project-pipeline.yml  # Example multi-project pipeline
└── README.md                       # This file
```

## Prerequisites

### Service Connection Setup

Before using these templates, create a service connection in your Azure DevOps project:

1. Go to **Project Settings** > **Service Connections**
2. Click **New Service Connection**
3. Select **Azure Repos/Team Foundation Server**
4. Configure:
   - **URL**: `https://dev.azure.com/YourOrganization`
   - **Name**: `SharedTemplates-ServiceConnection`
   - **Authentication**: Personal Access Token with Build (Read) permissions

### Required Permissions

- **Templates Repository**: Read access for all projects, Write access only for DevOps team
- **Service Connections**: Minimize permissions, use dedicated PATs
- **Branch Protection**: Require PR reviews for main branch

## Quick Start

### 1. Java Maven Project

Create `azure-pipelines.yml` in your project root:

```yaml
trigger:
  branches:
    include: ["main", "develop"]
  paths:
    include: ["src/**", "pom.xml", "azure-pipelines.yml"]

resources:
  repositories:
    - repository: templates
      type: git
      name: DevOps/Templates
      endpoint: SharedTemplates-ServiceConnection
      ref: refs/heads/main

variables:
  - template: variables/common-variables.yml@templates
  - template: variables/java-variables.yml@templates

stages:
  - template: stages/java-ci-stage.yml@templates
    parameters:
      buildTool: "maven"
      buildConfiguration: "release"
      projectPath: "pom.xml"
      vmImage: "ubuntu-latest"
      javaVersion: "11"
      runTests: true
      testType: "all"
      coverageThreshold: 80
```

### 2. Angular Project

Create `azure-pipelines.yml` in your project root:

```yaml
trigger:
  branches:
    include: ["main", "develop"]
  paths:
    include: ["src/**", "package.json", "angular.json", "azure-pipelines.yml"]

resources:
  repositories:
    - repository: templates
      type: git
      name: DevOps/Templates
      endpoint: SharedTemplates-ServiceConnection
      ref: refs/heads/main

variables:
  - template: variables/common-variables.yml@templates
  - template: variables/angular-variables.yml@templates

stages:
  - template: stages/angular-ci-stage.yml@templates
    parameters:
      nodeVersion: "18"
      buildConfiguration: "production"
      projectPath: "."
      vmImage: "ubuntu-latest"
      runTests: true
      testType: "all"
      coverageThreshold: 80
      buildOptimization: true
```

### 3. NuGet (.NET) Project

Create `azure-pipelines.yml` in your project root:

```yaml
trigger:
  branches:
    include: ["main", "develop"]
  paths:
    include: ["src/**", "**/*.csproj", "**/*.sln", "nuget.config", "azure-pipelines.yml"]

resources:
  repositories:
    - repository: templates
      type: git
      name: DevOps/Templates
      endpoint: SharedTemplates-ServiceConnection
      ref: refs/heads/main

variables:
  - template: variables/common-variables.yml@templates
  - template: variables/nuget-variables.yml@templates

stages:
  - template: stages/nuget-ci-stage.yml@templates
    parameters:
      dotnetVersion: "8.0.x"
      buildConfiguration: "Release"
      projectPath: "."
      projects: "**/*.sln"
      vmImage: "ubuntu-latest"
      runTests: true
      testType: "all"
      coverageThreshold: 80
      packPackages: true
```

Tag integration tests with `[Trait("Category", "Integration")]` (xUnit), `[Category("Integration")]` (NUnit), or `[TestCategory("Integration")]` (MSTest) so `testType: unit` or `testType: integration` can filter them.

## Template Parameters

### Java Build Job Parameters

| Parameter            | Type    | Default          | Description                                |
| -------------------- | ------- | ---------------- | ------------------------------------------ |
| `buildTool`          | string  | 'maven'          | Build tool ('maven' or 'gradle')           |
| `buildConfiguration` | string  | 'release'        | Build configuration ('debug' or 'release') |
| `projectPath`        | string  | '\*\*/pom.xml'   | Path to project files                      |
| `vmImage`            | string  | 'ubuntu-latest'  | Agent VM image                             |
| `artifactName`       | string  | 'java-artifacts' | Name for published artifacts               |
| `javaVersion`        | string  | '11'             | Java version to use                        |
| `skipTests`          | boolean | false            | Whether to skip tests                      |
| `publishTestResults` | boolean | true             | Whether to publish test results            |

### Angular Build Job Parameters

| Parameter            | Type    | Default             | Description                          |
| -------------------- | ------- | ------------------- | ------------------------------------ |
| `nodeVersion`        | string  | '18'                | Node.js version to use               |
| `buildConfiguration` | string  | 'production'        | Build configuration                  |
| `projectPath`        | string  | '.'                 | Path to Angular project              |
| `vmImage`            | string  | 'ubuntu-latest'     | Agent VM image                       |
| `artifactName`       | string  | 'angular-artifacts' | Name for published artifacts         |
| `buildOptimization`  | boolean | true                | Whether to enable build optimization |
| `sourceMap`          | boolean | false               | Whether to generate source maps      |
| `cacheDependencies`  | boolean | true                | Whether to cache node_modules        |

### Java Test Job Parameters

| Parameter           | Type    | Default         | Description                                  |
| ------------------- | ------- | --------------- | -------------------------------------------- |
| `buildTool`         | string  | 'maven'         | Build tool ('maven' or 'gradle')             |
| `projectPath`       | string  | '\*\*/pom.xml'  | Path to project files                        |
| `vmImage`           | string  | 'ubuntu-latest' | Agent VM image                               |
| `testType`          | string  | 'all'           | Type of tests ('unit', 'integration', 'all') |
| `coverageThreshold` | number  | 80              | Minimum code coverage percentage             |
| `parallelTests`     | boolean | true            | Whether to run tests in parallel             |

### Angular Test Job Parameters

| Parameter           | Type    | Default         | Description                           |
| ------------------- | ------- | --------------- | ------------------------------------- |
| `nodeVersion`       | string  | '18'            | Node.js version to use                |
| `projectPath`       | string  | '.'             | Path to Angular project               |
| `vmImage`           | string  | 'ubuntu-latest' | Agent VM image                        |
| `testType`          | string  | 'all'           | Type of tests ('unit', 'e2e', 'all')  |
| `coverageThreshold` | number  | 80              | Minimum code coverage percentage      |
| `headless`          | boolean | true            | Whether to run tests in headless mode |
| `parallelTests`     | boolean | true            | Whether to run tests in parallel      |

### NuGet Build Job Parameters

| Parameter            | Type    | Default            | Description                                      |
| -------------------- | ------- | ------------------ | ------------------------------------------------ |
| `dotnetVersion`      | string  | '8.0.x'            | .NET SDK version to use                          |
| `buildConfiguration` | string  | 'Release'          | Build configuration ('Debug' or 'Release')       |
| `projectPath`        | string  | '.'                | Path to .NET project or solution                 |
| `projects`           | string  | '\*\*/\*.sln'      | Glob for solution or project files               |
| `vmImage`            | string  | 'ubuntu-latest'    | Agent VM image                                   |
| `artifactName`       | string  | 'nuget-artifacts'  | Name for published artifacts                     |
| `cacheDependencies`  | boolean | true               | Whether to cache NuGet packages                  |
| `packPackages`       | boolean | true               | Whether to pack `.nupkg` files                   |
| `packageVersion`     | string  | ''                 | Version to apply when packing (project version if empty) |
| `includeSymbols`     | boolean | false              | Whether to include symbol packages               |

### NuGet Test Job Parameters

| Parameter            | Type    | Default         | Description                                         |
| -------------------- | ------- | --------------- | --------------------------------------------------- |
| `dotnetVersion`      | string  | '8.0.x'         | .NET SDK version to use                             |
| `projectPath`        | string  | '.'             | Path to .NET project or solution                    |
| `projects`           | string  | '\*\*/\*.sln'   | Glob for solution or project files                  |
| `vmImage`            | string  | 'ubuntu-latest' | Agent VM image                                      |
| `testType`           | string  | 'all'           | Type of tests ('unit', 'integration', 'all')        |
| `coverageThreshold`  | number  | 80              | Minimum code coverage percentage                    |
| `parallelTests`      | boolean | true            | Whether to run tests in parallel                    |
| `buildConfiguration` | string  | 'Release'       | Build configuration ('Debug' or 'Release')          |

### NuGet Lint Job Parameters

| Parameter        | Type    | Default         | Description                                      |
| ---------------- | ------- | --------------- | ------------------------------------------------ |
| `dotnetVersion`  | string  | '8.0.x'         | .NET SDK version to use                          |
| `projectPath`    | string  | '.'             | Path to .NET project or solution                 |
| `projects`       | string  | '\*\*/\*.sln'   | Glob for solution or project files               |
| `vmImage`        | string  | 'ubuntu-latest' | Agent VM image                                   |
| `severity`       | string  | 'warn'          | Minimum severity ('info', 'warn', 'error')       |
| `continueOnError`| boolean | false           | Whether to continue on lint errors               |

## Advanced Usage

### Multi-Project Pipeline

For projects with both Java backend and Angular frontend:

```yaml
stages:
  # Java Backend CI
  - stage: JavaBackendCI
    displayName: "Java Backend CI"
    jobs:
      - template: jobs/java-build-job.yml@templates
        parameters:
          buildTool: "maven"
          projectPath: "backend/pom.xml"
          artifactName: "java-backend-artifacts"

  # Angular Frontend CI
  - stage: AngularFrontendCI
    displayName: "Angular Frontend CI"
    dependsOn: JavaBackendCI
    jobs:
      - template: jobs/angular-build-job.yml@templates
        parameters:
          projectPath: "frontend"
          artifactName: "angular-frontend-artifacts"
```

### Custom Variables

Override default variables in your pipeline:

```yaml
variables:
  - template: variables/java-variables.yml@templates
  - name: javaVersion
    value: "17"
  - name: coverageThreshold
    value: 90
```

### Conditional Jobs

Use conditional logic based on branch or environment:

```yaml
- ${{ if eq(variables['Build.SourceBranch'], 'refs/heads/main') }}:
    - template: jobs/security-scan-job.yml@templates
      parameters:
        scanType: "full"
```

## Best Practices

### 1. Version Pinning

Pin to specific template versions for production stability:

```yaml
resources:
  repositories:
    - repository: templates
      type: git
      name: DevOps/Templates
      endpoint: SharedTemplates-ServiceConnection
      ref: refs/tags/v2.1.0 # Specific version
```

### 2. Security

- Never hardcode secrets in templates
- Use Azure Key Vault references: `$(KeyVault.SecretName)`
- Parameterize all environment-specific values
- Use minimal required permissions for service connections

### 3. Performance

- Enable dependency caching where possible
- Use parallel jobs for independent tasks
- Implement smart triggering (path-based, branch-based)
- Optimize artifact publishing and consumption

### 4. Testing

- Test template changes with example pipelines
- Validate YAML syntax before merging
- Use feature branches for template development
- Create comprehensive test coverage

## Troubleshooting

### Common Issues

1. **Template Not Found**

   - Verify service connection name matches exactly
   - Check repository reference format: `ProjectName/RepoName`
   - Ensure PAT has sufficient permissions

2. **Parameter Errors**

   - Validate parameter types (string, number, boolean, object)
   - Check for required vs optional parameters
   - Verify parameter names match exactly (case-sensitive)

3. **Cross-Project Access Issues**
   - Confirm projects are in same Azure DevOps organization
   - Verify service connection is created in consuming project
   - Check if pipeline has permission to use service connection

### Debug Mode

Enable debug logging in your pipeline:

```yaml
variables:
  system.debug: true
```

## Contributing

### Development Workflow

1. Create feature branch from `develop`
2. Make changes with comprehensive parameter documentation
3. Test changes with example pipelines
4. Create PR with detailed description of changes
5. After approval, merge to `develop`
6. Create release tag when ready for production use

### Adding New Templates

1. Follow naming conventions
2. Include comprehensive parameter documentation
3. Add usage example in template header comment
4. Update this README.md with new template information
5. Create test pipeline to validate functionality

## Support

For issues and questions:

1. Check the troubleshooting section above
2. Review example pipelines in `/examples/`
3. Create an issue in the templates repository
4. Contact the DevOps team

## Version History

- **v2.2.0**: Added NuGet (.NET) lint, test, build, pack, and publish templates
- **v2.1.0**: Added Angular support, improved Java templates
- **v2.0.0**: Major refactoring, added stage templates
- **v1.0.0**: Initial release with basic Java templates

---

**Note**: This repository serves as the central template library for the organization. All changes should be reviewed and tested thoroughly before merging to maintain pipeline stability across all consuming projects.
