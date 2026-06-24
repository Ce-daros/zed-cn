use gpui::{IntoElement, ParentElement};
use ui::{List, ListBulletItem, prelude::*};

/// Centralized definitions for Zed AI plans
pub struct PlanDefinitions;

impl PlanDefinitions {
    pub fn free_plan(&self) -> impl IntoElement {
        List::new()
            .child(ListBulletItem::new("2,000 次已接受的编辑预测"))
            .child(ListBulletItem::new(
                "使用你的 AI API 密钥可无限提问",
            ))
            .child(ListBulletItem::new("可无限使用外部智能体"))
    }

    pub fn sign_in_upsell(&self) -> impl IntoElement {
        List::new()
            .child(ListBulletItem::new("无限制编辑预测"))
            .child(ListBulletItem::new("Zed 智能体内含价值 20 美元的额度"))
            .child(ListBulletItem::new("无需信用卡"))
    }

    pub fn pro_trial(&self, period: bool) -> impl IntoElement {
        List::new()
            .child(ListBulletItem::new("Zed 智能体内含价值 20 美元的额度"))
            .child(ListBulletItem::new("无限制编辑预测"))
            .when(period, |this| {
                this.child(ListBulletItem::new(
                    "可试用 14 天，无需信用卡",
                ))
            })
    }

    pub fn pro_plan(&self) -> impl IntoElement {
        List::new()
            .child(ListBulletItem::new("Zed 智能体内含价值 5 美元的额度"))
            .child(ListBulletItem::new("超出 5 美元后按使用量计费"))
            .child(ListBulletItem::new("无限制编辑预测"))
    }

    pub fn business_plan(&self) -> impl IntoElement {
        List::new()
            .child(ListBulletItem::new("无限制编辑预测"))
            .child(ListBulletItem::new("按使用量计费"))
    }

    pub fn vip_plan(&self) -> impl IntoElement {
        List::new()
            .child(ListBulletItem::new("无限制编辑预测"))
            .child(ListBulletItem::new("Zed 智能体内含额度"))
    }

    pub fn student_plan(&self) -> impl IntoElement {
        List::new()
            .child(ListBulletItem::new("无限制编辑预测"))
            .child(ListBulletItem::new("Zed 智能体内含价值 10 美元的额度"))
            .child(ListBulletItem::new(
                "可选购额度包以支持额外使用量",
            ))
    }
}
