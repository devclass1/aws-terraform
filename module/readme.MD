## 📘 What is a Terraform Module?

A **Terraform Module** is a container for multiple resources that are used together to manage a specific infrastructure component. It is the fundamental unit of organization in Terraform configuration and enables **reusability**, **consistency**, and **modularity** in infrastructure code.

### ✅ Key Concepts

- **Root Module**: The main directory where Terraform is initialized and where configuration files are written (`main.tf`, `variables.tf`, etc.).
- **Child Module**: A reusable module defined in another directory or source (local or remote) that is called from the root module using the `module` block.

### 🔁 Benefits of Using Modules

- **Code Reusability**: Define once, use many times across environments or teams.
- **Simplified Management**: Logical separation of resources improves readability and maintainability.
- **Scalability**: Makes it easier to grow infrastructure code without complexity.
- **Standardization**: Enforces standards and best practices across teams.

### 📦 Example Module Usage

```hcl
module "ec2_instance" {
  source         = "./modules/ec2"
  instance_type  = "t2.micro"
  ami_id         = "ami-0c02fb55956c7d316"
}
```

In the above example, the `ec2_instance` module is sourced from a local `./modules/ec2` directory and reuses the same infrastructure logic to provision EC2 instances.

