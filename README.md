# Azure DevOps Templates Repository

This repository contains reusable Azure DevOps pipeline templates for Java and Angular projects. These templates follow DRY (Don't Repeat Yourself) principles and provide standardized CI/CD pipelines across your organization.

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

## 📁 Project Structure

```
/templates/
├── jobs/                    # Individual job templates
│   ├── java-build-job.yml   # Java build (Maven/Gradle)
│   ├── java-test-job.yml    # Java testing
│   ├── angular-build-job.yml # Angular build
│   └── angular-test-job.yml  # Angular testing
├── stages/                  # Complete stage templates
│   ├── java-ci-stage.yml    # Full Java CI stage
│   └── angular-ci-stage.yml # Full Angular CI stage
├── steps/                   # Reusable step templates
│   ├── setup-java.yml       # Java environment setup
│   ├── setup-nodejs.yml     # Node.js environment setup
│   ├── java-build-steps.yml # Java build steps
│   ├── java-test-steps.yml  # Java test steps
│   ├── angular-build-steps.yml # Angular build steps
│   ├── angular-test-steps.yml  # Angular test steps
│   ├── publish-artifacts.yml    # Artifact publishing
│   └── publish-test-results.yml # Test results publishing
├── variables/               # Variable templates
│   ├── common-variables.yml # Organization-wide variables
│   ├── java-variables.yml   # Java-specific variables
│   └── angular-variables.yml # Angular-specific variables
├── examples/                # Example pipelines
│   ├── java-maven-pipeline.yml    # Maven example
│   ├── java-gradle-pipeline.yml   # Gradle example
│   ├── angular-pipeline.yml       # Angular example
│   └── multi-project-pipeline.yml # Multi-project example
└── README.md               # Detailed documentation
```

## 🔧 Features

- **Java Support**: Maven and Gradle builds with comprehensive testing
- **Angular Support**: Node.js builds with unit and e2e testing
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
