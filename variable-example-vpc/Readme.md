# AWS VPC Setup using Terraform

This Terraform project creates an AWS Virtual Private Cloud (VPC) named `myvpc` with the CIDR block `172.20.0.0/16`, and includes two subnets:

- **App Subnet**: `172.20.10.0/24`
- **Work Subnet**: `172.20.20.0/24`

---

## 📁 Project Structure

```
.
├── main.tf          # Contains the main Terraform configuration
├── provider.tf      # AWS provider configuration
├── variables.tf     # Input variables for customization
├── output.tf        # Outputs after Terraform apply
└── README.md        # Project documentation
```

---

## ✅ Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- An AWS account
- AWS CLI configured (`aws configure`)

---

## 🚀 Usage

1. **Initialize the Terraform project**

   ```bash
   terraform init
   ```

2. **Review the planned actions**

   ```bash
   terraform plan
   ```

3. **Apply the configuration**

   ```bash
   terraform apply
   ```

4. **Confirm the outputs**

   After deployment, Terraform will output the VPC ID and Subnet IDs.

---

## 🛠️ Configuration

You can customize the AWS region and CIDR blocks in the `variables.tf` file:

```hcl
variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "172.20.0.0/16"
}

variable "app_subnet_cidr" {
  default = "172.20.10.0/24"
}

variable "work_subnet_cidr" {
  default = "172.20.20.0/24"
}
```

---

## 📤 Outputs

After successful execution, the following outputs will be shown:

- VPC ID
- App Subnet ID
- Work Subnet ID

---

## 📌 Notes

- Availability zones are hardcoded as `<region>a` and `<region>b`. Modify `main.tf` if you need dynamic selection.
- This setup creates **private subnets only**. Add Internet Gateway and Route Tables if public access is required.

---

## 📚 References

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)


---

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

---

## 📬 License

This project is licensed under the MIT License.
