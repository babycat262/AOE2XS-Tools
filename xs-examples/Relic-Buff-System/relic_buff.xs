/// 修道院圣物驻扎提供若干单位的属性加成 [作者：babycat] ///

const int relic_var = 7;    // 记录捕获圣物数的触发器变量
const int station_P = 3;    // 圣物驻扎的玩家
const int effect_P = 1;    // 属性加成作用的玩家


rule relics_buff
    inactive
    group RelicBuffs
    minInterval 0
    priority 100
{
    static int relic_amts = 0;    // 圣物获取数/增益倍率 [1圣物 = 1倍]
    static int relic_wave = 0;    // 当前时刻圣物变化数量
    if(relic_amts==0) {xsSetRuleMinIntervalSelf(1);}    // rule首次执行后改间隔为 1s
    int relics = xsPlayerAttribute(station_P, 7);
    if((relics > 0) && (relics == relic_amts)) {}
    else if(relics == 0) 
    {// 当前拥有圣物数量减为0，清空增益
        xsEffectAmount(4, 1123, 0, -5*relic_amts, effect_P);    // 爪刀勇士 ： +5 生命值/圣物
        xsEffectAmount(4, 036, 5, -0.1*relic_amts, effect_P);    // 手推炮 ： +0.1 移动速度/圣物
        xsEffectAmount(4, 731, 1, -1*relic_amts, effect_P);    // 成吉思汗 ： +1 视野/圣物
        xsEffectAmount(4, 38, 8, -3*256-relic_amts, effect_P);    // 骑士 ： +1 护甲/圣物
        xsEffectAmount(4, 38, 8, -4*256-relic_amts, effect_P);    // 骑士 ： +1 盾牌/圣物
        xsEffectAmount(4, 38, 9, -4*256-relic_amts, effect_P);    // 骑士 ： +1 攻击力/圣物
        relic_amts = relics;
        xsSetTriggerVariable(relic_var, relic_amts);
    }
    else 
    {
        relic_wave = relics - relic_amts;
        // 设置单位其他属性（不含攻防）
        xsEffectAmount(4,1123, 0, 5*relic_wave, effect_P);
        xsEffectAmount(4, 036, 5, 0.15*relic_wave, effect_P);
        xsEffectAmount(4, 731, 1, 1*relic_wave, effect_P);
        // 设置攻防
        int AD = 1;    // 攻防BUFF变化标志位：relic_wave>0时 AD=1；relic_wave<0时 AD=-1
        if(relic_wave < 0) {AD = -1; relic_wave = 1*abs(relic_wave);}
        //圣物数量变化时，单位攻防随之变化
        xsEffectAmount(4, 38, 8, AD*(3*256+relic_wave), effect_P);
        xsEffectAmount(4, 38, 8, AD*(4*256+relic_wave), effect_P);
        xsEffectAmount(4, 38, 9, AD*(4*256+relic_wave), effect_P);
        // 同步捕获圣物数变量
        relic_amts = relics;
        xsSetTriggerVariable(relic_var, relic_amts);
        //xsChatData("<GREEN>Relics Amount: "+ relic_amts);
    }
}
void open_relics_buff() {xsEnableRule("relics_buff");}
void close_relics_buff(){xsDisableRule("relics_buff");} 

void unit_initial_attrs() 
{// 初始化单位属性
    xsEffectAmount(4, 1123, 0, 0-10, 1);
    xsEffectAmount(0, 36, 5, 0.6,  1);
    xsEffectAmount(4, 731, 1, 0-4, 1);
}


void main() 
{
    unit_initial_attrs();
    //xsEnableRule("relics_buff");
    
}

