# Azure DevOps Templates Repository

This repository contains reusable Azure DevOps pipeline templates for Java, Angular, and NuGet (.NET) projects. These templates follow DRY (Don't Repeat Yourself) principles and provide standardized CI/CD pipelines across your organization.

## 🚀 Quick Start

### For Java Projects

```yaml
# azure-pipelines.yml
resources:
  repositories:
    - repository: templates
      type: git
      name: DevOps/Templates
      endpoint: SharedTemplates-ServiceConnection

stages:
  - template: stages/java-ci-stage.yml@templates
    parameters:
      buildTool: "maven"
      javaVersion: "11"
```

### For Angular Projects

```yaml
# azure-pipelines.yml
resources:
  repositories:
    - repository: templates
      type: git
      name: DevOps/Templates
      endpoint: SharedTemplates-ServiceConnection

stages:
  - template: stages/angular-ci-stage.yml@templates
    parameters:
      nodeVersion: "18"
      buildConfiguration: "production"
```

### For NuGet (.NET) Projects

```yaml
# azure-pipelines.yml
resources:
  repositories:
    - repository: templates
      type: git
      name: DevOps/Templates
      endpoint: SharedTemplates-ServiceConnection

stages:
  - template: stages/nuget-ci-stage.yml@templates
    parameters:
      dotnetVersion: "8.0.x"
      buildConfiguration: "Release"
      packPackages: true
```

## 📁 Project Structure

```
/templates/
├── jobs/                    # Individual job templates
│   ├── java-build-job.yml   # Java build (Maven/Gradle)
│   ├── java-test-job.yml    # Java testing
│   ├── angular-build-job.yml # Angular build
│   ├── angular-test-job.yml  # Angular testing
│   ├── nuget-build-job.yml   # NuGet/.NET build and pack
│   ├── nuget-test-job.yml    # NuGet/.NET testing
│   └── nuget-lint-job.yml    # NuGet/.NET lint (dotnet format)
├── stages/                  # Complete stage templates
│   ├── java-ci-stage.yml    # Full Java CI stage
│   ├── angular-ci-stage.yml # Full Angular CI stage
│   └── nuget-ci-stage.yml   # Full NuGet/.NET CI stage
├── steps/                   # Reusable step templates
│   ├── setup-java.yml       # Java environment setup
│   ├── setup-nodejs.yml     # Node.js environment setup
│   ├── setup-dotnet.yml     # .NET SDK environment setup
│   ├── java-build-steps.yml # Java build steps
│   ├── java-test-steps.yml  # Java test steps
│   ├── angular-build-steps.yml # Angular build steps
│   ├── angular-test-steps.yml  # Angular test steps
│   ├── nuget-build-steps.yml   # NuGet restore, build, pack
│   ├── nuget-test-steps.yml    # NuGet test steps
│   ├── nuget-lint-steps.yml    # NuGet lint steps
│   ├── nuget-push-steps.yml    # Push packages to a feed
│   ├── publish-artifacts.yml    # Artifact publishing
│   └── publish-test-results.yml # Test results publishing
├── variables/               # Variable templates
│   ├── common-variables.yml # Organization-wide variables
│   ├── java-variables.yml   # Java-specific variables
│   ├── angular-variables.yml # Angular-specific variables
│   └── nuget-variables.yml   # NuGet/.NET-specific variables
├── examples/                # Example pipelines
│   ├── java-maven-pipeline.yml    # Maven example
│   ├── java-gradle-pipeline.yml   # Gradle example
│   ├── angular-pipeline.yml       # Angular example
│   ├── nuget-pipeline.yml         # NuGet/.NET example
│   └── multi-project-pipeline.yml # Multi-project example
└── README.md               # Detailed documentation
```

## 🔧 Features

- **Java Support**: Maven and Gradle builds with comprehensive testing
- **Angular Support**: Node.js builds with unit and e2e testing
- **NuGet Support**: .NET restore, build, pack, test, lint, and feed publish
- **Flexible Configuration**: Extensive parameterization for customization
- **Code Coverage**: Built-in coverage reporting and thresholds
- **Artifact Management**: Standardized artifact publishing
- **Multi-Project Support**: Templates for combined Java/Angular projects
- **Security Best Practices**: Secure by default with proper secret management

## 📚 Documentation

For detailed usage instructions, parameter reference, and examples, see:

- [Templates Documentation](templates/README.md)
- [Example Pipelines](templates/examples/)

## 🤝 Contributing

1. Create a feature branch from `develop`
2. Make changes with comprehensive documentation
3. Test with example pipelines
4. Submit a pull request with detailed description
