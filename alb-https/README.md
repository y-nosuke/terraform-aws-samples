# alb-https

## 事前準備

### .direnv の作成

``` sh
direnv edit .

export AWS_ACCOUNT_ID=(Account ID)
export AWS_ACCESS_KEY_ID=(Access key ID)
export AWS_SECRET_ACCESS_KEY=(Secret access key)
export AWS_DEFAULT_REGION=ap-northeast-1
```

### terraform の初期化

```sh
rm -rf .terraform
terraform init -backend-config=backend.hcl
```

## 実行

```sh
# リソース作成
terraform apply

# リソース削除
terraform destroy
```

## 参考

- [Terraform Registry Resource: aws_acm_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate)
- [Terraform Registry Resource: acm_certificate_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation)
