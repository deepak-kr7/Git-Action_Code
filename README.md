# Azure Terraform Setup with GitHub Actions Pipeline

Ye repository ek complete starter setup hai jisme Terraform ke zariye Azure me **Resource Group**, **Storage Account**, aur **Virtual Network (VNet)** create hota hai, aur state file ko Azure Blob Storage me secure backend ke tor par maintain kiya jata hai.

---

## 📁 Repository Structure

- **`providers.tf`**: Azure provider setup aur remote backend configuration.
- **`main.tf`**: RG, Storage Account, VNet aur Subnet ki definitions.
- **`variables.tf`**: Variables ki declarations.
- **`terraform.tfvars`**: Variables ki values.
- **`outputs.tf`**: Resources ki output details (Name, ID, etc.).
- **`.github/workflows/terraform.yml`**: GitHub Actions CI/CD Pipeline configuration file.

---

## 🚀 Setup Steps (Step-by-Step Guide)

### 1️⃣ Azure Remote Backend Storage Account Banao (One-Time Setup)
Terraform State (`.tfstate`) file ko manage karne ke liye Azure me pehle se ek Storage Account hona zaruri hai.
Azure CLI ya Portal se ye command chala kar backend create karein:

```bash
# 1. Resource Group create karein
az group create --name tfstate-rg --location eastus

# 2. Storage Account create karein (Small letters aur numbers, global unique name)
az storage account create --name tfstateacct12345 --resource-group tfstate-rg --sku Standard_LRS

# 3. Blob Container create karein
az storage container create --name tfstate --account-name tfstateacct12345
```

> **Note**: Agar aapne alag naam rakha hai toh `providers.tf` me `storage_account_name` aur `resource_group_name` update kar dein.

---

### 2️⃣ Azure Service Principal Banao (GitHub Authentication ke liye)
GitHub Actions ko Azure me deployment ke permission dene ke liye Azure Service Principal banayein:

```bash
az ad sp create-for-rbac --name "github-actions-terraform" --role "Contributor" --scopes "/subscriptions/YOUR_AZURE_SUBSCRIPTION_ID" --sdk-auth
```

Is command ke output se aapko JSON output milega jisme ye 4 details hongi:
- `clientId`
- `clientSecret`
- `subscriptionId`
- `tenantId`

---

### 3️⃣ GitHub Secrets Add Karein
Aapne GitHub Repository par jaayein:
**Settings -> Secrets and variables -> Actions -> New repository secret**

Neeche diye gaye 4 secrets add karein:

| Secret Name | Description |
| :--- | :--- |
| `AZURE_CLIENT_ID` | Service Principal ka Application (client) ID |
| `AZURE_CLIENT_SECRET` | Service Principal ka Secret value |
| `AZURE_SUBSCRIPTION_ID` | Aapki Azure Subscription ID |
| `AZURE_TENANT_ID` | Aapki Azure Directory (tenant) ID |

---

### 4️⃣ Pull Request & Code Review Workflow

Pipeline ko 2 parts me split kiya gaya hai taaki Code Review compulsory ho:

#### 🟢 Phase 1: PR Raise ya Update Hone Par (`terraform-plan`)
1. Developer a-new branch create karke changes push karta hai aur `main` branch me **Pull Request (PR)** raise karta hai.
2. Pipeline automatic run hakar:
   - `terraform fmt -check` (Format check)
   - `terraform init` (Backend setup)
   - `terraform validate` (Syntax check)
   - `terraform plan` (Azure changes check)
3. Pipeline automatic PR par **Terraform Plan Result** post kar deti hai code review ke liye.

#### 🔴 Phase 2: PR Approve & Merge Hone Par (`terraform-apply`)
1. Reviewer PR ke status aur Plan output ko review karke **Approve** karta hai.
2. Merge to `main` hone par `terraform-apply` job chalta hai aur Azure par resources actually create/update ho jaate hain.

---

### 🛡️ Mandatory PR Review Enforcement (GitHub Branch Protection Rules)
Kaunibhi developer bina review ke directly `main` par push na kare, iske liye GitHub me Settings configure karein:

1. Apni GitHub Repository me jaakar **Settings** tab par click karein.
2. Left menu me **Branches** par click karein aur **Add branch protection rule** par click karein.
3. **Branch name pattern**: `main` likhein.
4. Neeche diye options check karein:
   - ✅ **Require a pull request before merging**
   - ✅ **Require approvals** (Minimum 1 approval set karein)
   - ✅ **Require status checks to pass before merging** (`Terraform Plan & Code Review (PR)` select karein)
5. **Save changes** par click karein.

