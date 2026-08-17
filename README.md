# Azure Terraform Setup with Azure DevOps (ADO) Pipeline

Ye repository ek complete starter setup hai jisme Terraform ke zariye Azure me **Resource Group**, **Storage Account**, aur **Virtual Network (VNet)** create hota hai, aur state file ko Azure Blob Storage me secure backend ke tor par maintain kiya jata hai using **Azure DevOps Pipelines**.

---

## 📁 Repository Structure

- **`providers.tf`**: Azure provider setup aur remote backend configuration.
- **`main.tf`**: RG, Storage Account, VNet aur Subnet ki definitions.
- **`variables.tf`**: Variables ki declarations.
- **`terraform.tfvars`**: Variables ki values.
- **`outputs.tf`**: Resources ki output details (Name, ID, etc.).
- **`azure-pipelines.yml`**: Azure DevOps CI/CD Pipeline configuration file.

---

## 🚀 Setup Steps (Step-by-Step Guide for Azure DevOps)

### 1️⃣ Azure Remote Backend Storage Account Banao (One-Time Setup)
Terraform State (`.tfstate`) file ko manage karne ke liye Azure me pehle se ek Storage Account hona zaruri hai.
Azure CLI ya Portal se ye command chala kar backend create karein:

```bash
# 1. Resource Group create karein
az group create --name cicd_test --location eastus

# 2. Storage Account create karein (Small letters aur numbers, global unique name)
az storage account create --name storagecicd12 --resource-group cicd_test --sku Standard_LRS

# 3. Blob Container create karein
az storage container create --name cicdcontainer --account-name storagecicd12
```

---

### 2️⃣ Azure DevOps Service Connection Setup
Azure DevOps ko Azure Subscription me authentication dene ke liye Service Connection setup karein:

1. Azure DevOps project me jaakar **Project Settings** (bottom left) par click karein.
2. **Service connections** -> **New service connection** select karein.
3. **Azure Resource Manager** select karke **Service Principal (automatic)** ya **Workload Identity federation** option chunein.
4. Subscription select karke Service Connection ka naam `azure-service-connection` rakhein.
5. Save karein aur pipeline permissions grant karein.

---

### 3️⃣ Azure DevOps Pipeline Configure Karein

1. Azure DevOps me **Pipelines** -> **New pipeline** par click karein.
2. Code location: **Azure Repos Git** / **GitHub**.
3. Existing Azure Pipelines YAML file select karein: `azure-pipelines.yml`.
4. Run par click karein.

---

### 4️⃣ Pull Request & Code Review Workflow

Pipeline ko 2 Stages me divide kiya gaya hai:

#### 🟢 Stage 1: Validate & Plan (PR & Branch Push)
- `terraform fmt -check` (Format check)
- `terraform init` (Remote Backend initialization)
- `terraform validate` (Syntax validation)
- `terraform plan` (Execution plan generation)

#### 🔴 Stage 2: Apply (Post Merge to `main`)
- `main` branch me PR approve hokar merge hone par automatic `terraform apply -auto-approve` chalega.
