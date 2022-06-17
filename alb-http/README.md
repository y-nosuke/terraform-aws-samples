# alb-http

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

- [Terraform Registry Resource: aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)
- [Terraform Registry Resource: aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener)
- [Terraform Registry Resource: aws_lb_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule)
- [Terraform Registry Resource: aws_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group)
- [Terraform Registry Resource: aws_lb_target_group_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment)
