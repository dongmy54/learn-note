where(Sequel.lit("select * from accounts where id = ?",15)).first

all.where(Sequel.lit("select * from accounts")).all

PageTemplateCmoponent.where(Sequel.lit("component_id in (?) and template_id = ?", delete_ids, @template.id)).destroy

payment_method_err << I18n.t("model.common.not_exist", :title => "id为#{bank_code_id}的BankCode") unless DB[:bank_codes].where(Sequel.lit("id = ? and #{payment_method.pay_type[0,6]}_code is not null and #{payment_method.pay_type[0,6]}_code != ''", bank_code_id.to_i)).first

CouponGroup.where(Sequel.lit("prefix = ? and ctype='single' and is_saved = true and is_available = true and site_id = ? and actived_at <= now() and ((no_expires = true) or (no_expires = false and now() <= expired_at)) ", code, siteid)).first

Customer.where(Sequel.lit("credit >= ? and credit < ? and siteid = ?", credits, next_level.credits, site_id)).update(:customer_level_id => id)

Customer.where(Sequel.lit("credit >= ? and siteid = ?", credits, site_id)).update(:customer_level_id => id)

if pre_level = CustomerLevel.where(Sequel.lit("credits < ? and site_id = ?", self.credits, self.site_id)).reverse_order(:credits).first

if next_level = CustomerLevel.where(Sequel.lit("credits > ? and site_id = ? and id != ?", credits, self.site_id, self.id)).order(:credits).first

PageTemplateComponent.where(Sequel.lit("component_id = ?", self.id)).destroy

unless coupon_group = CouponGroup.where(Sequel.lit("id = ? and ctype='normal' and is_saved = true and is_available = true and site_id = ? and actived_at <= now() and ((no_expires = true) or (no_expires = false and now() <= expired_at))", coupon.coupon_group_id, @siteid)).first