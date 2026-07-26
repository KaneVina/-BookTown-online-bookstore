# BookTown

Online Bookstore System

BookTown is a full-stack Java web application for an online bookstore — customers can browse, search, purchase and review books, while the store staff manage the system from a dashboard.

Academic project — FPT University, class SE1912.

---

## Tech Stack

**Frontend**
- HTML5, CSS3, JavaScript
- Tailwind CSS
- JSP with JSTL

**Backend**
- Java, Jakarta EE 10 (Servlets), MVC2 architecture

**Database**
- Microsoft SQL Server (via `mssql-jdbc`)

**Integrations**
- Cloudinary — image upload
- VNPAY — online payment
- Google OAuth — social login
- Jakarta Mail — email/OTP delivery

**Build and Runtime**
- Maven
- Apache Tomcat 10.1
- NetBeans IDE

---

## Getting Started

### Prerequisites

| Tool | Version |
|---|---|
| JDK | 11+ |
| Apache Tomcat | 10.1 |
| SQL Server | Any recent version |
| IDE | NetBeans (recommended) |

### Setup

```bash
# Clone the repository
git clone https://github.com/KaneVina/-BookTown-online-bookstore.git

# Open the project in your IDE
# Configure a Tomcat 10.1 server
# Create the SQL Server database and update connection settings
#   (see src/main/java/utils/DBContext.java)
# Configure Google OAuth and VNPAY credentials in web.xml / VNPayConfig
# Build and run the project
```

---

## Project Structure

```
BookTown/
├── src/main/java/
│   ├── controller/       Servlets
│   ├── dao/              Data access objects
│   ├── model/            Entity classes
│   ├── filter/           Servlet filters
│   └── utils/            Shared utilities (DB, email, uploads, config)
├── src/main/webapp/
│   ├── views/             JSP pages
│   ├── assets/            CSS, JS, images
│   └── WEB-INF/           web.xml, beans.xml
├── pom.xml
└── README.md
```

---

## Team

Supervisor: Le Thi Thu Lan — Class: SE1912

| # | Name | Student ID | Role |
|---|---|---|---|
| 1 | Truong Ngoc Tran | CE180829 | Leader |
| 2 | Nguyen Phuc Khang | CE181578 | Member |
| 3 | Duong Nguyen Kim Chi | CE191215 | Member |
| 4 | Tran Lam Tuan Khoi | CE190993 | Member |
| 5 | Ngo Le Tien Dat | CE170010 | Member |

Contact: wtskane@gmail.com / khangnpce181578@fpt.edu.vn
