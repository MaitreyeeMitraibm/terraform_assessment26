terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key="ASIA5WA4KWZWZSX5HNOD"
  secret_key="QIgEfUZ+xzeal5qgmTU4jX2H+jd5m1pzb+PVR0fe"
  token="FwoGZXIvYXdzEOP//////////wEaDC1SjrXlqgvJEreg2SKvAaGOkaEdhqoZCsMaqd2qR2wzTQQ5cgceo+b63UZnfT1APO1FrgEzgnFQr969W9CWSZIgwJCpAY3/GIUpAx/FFhKslI353Ey8ddxy83O5SaojrY6P3zzTcHL5W88BXIGTojJbHfH7OUxRz1ZSIi/qam4bHeNtlCG0wCQA9lXHRXHDk51QmqaXmMRCG1Qer+aHoYHVH32Vok22agn0AKNxISJKZYVPa43En+nieg4sAO0o2b3xrgYyLTt60dXD2ZZUXrZ+mJtmADMXOe3J2PcYg7PWwT/qMseVNU9LKLrQE/c8WwLOwQ=="
}
