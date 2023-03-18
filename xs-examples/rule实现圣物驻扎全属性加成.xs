/// 修道院圣物驻扎提供属单位的性增益（测试） ///
const int var_relics = 7;  // 同步圣物数的触发器变量
int relics_amt = 0;  // 圣物获取数|增益倍率：[1圣物 = 1倍]

rule sanatorium_relics_buff
    inactive
    group Relics
    minInterval 1
    runImmediately
{
    int relics = xsPlayerAttribute(1, 7);
    if((relics != 0) && (relics == relics_amt)) {}
    else if(relics == 0) // 当前拥有圣物数量为0，清空增益
    {
        xsEffectAmount(4, 749, 0, -5*relics_amt, 1);
        xsEffectAmount(4, 749, 5, -0.1*relics_amt, 1);
        xsEffectAmount(4, 749, 8, -3*256-relics_amt, 1);
        xsEffectAmount(4, 749, 8, -4*256-relics_amt, 1);
        xsEffectAmount(4, 749, 9, -4*256-relics_amt, 1);
        xsEffectAmount(4,1732, 0, -10*relics_amt, 1);
        relics_amt = 0;
        xsSetTriggerVariable(var_relics, relics_amt);
    }
    else 
    {
        int wave_ = relics - relics_amt ;
        relics_amt = relics_amt + wave_;
        // 设置单位其他属性（不含攻防）
        xsEffectAmount(4, 749, 0, 5*wave_, 1);
        xsEffectAmount(4, 749, 5, 0.1*wave_, 1);
        xsEffectAmount(4,1732, 0, 10*wave_, 1);
        if(wave_ > 0) {//圣物较之前增加
            //xsChatData("<GREEN>relic_wave: "+wave_);
            xsEffectAmount(4, 749, 8, 3*256+wave_, 1);
            xsEffectAmount(4, 749, 8, 4*256+wave_, 1);
            xsEffectAmount(4, 749, 9, 4*256+wave_, 1);
        }
        else if(wave_ < 0) {//圣物较之前减少
            //xsChatData("<RED>relic_wave: "+wave_);
            xsEffectAmount(4, 749, 8, -3*256+wave_, 1);
            xsEffectAmount(4, 749, 8, -4*256+wave_, 1);
            xsEffectAmount(4, 749, 9, -4*256+wave_, 1);
        }
        relics_amt = relics;    // relics资源同步变量
        xsSetTriggerVariable(var_relics, relics_amt);
    }
}
void run_relics_buff() {xsEnableRule("sanatorium_relics_buff");}


void main() 
{
    xsEffectAmount(4, 749, 9, -1024-11, 1);
    xsEffectAmount(0, 749, 46, 1, 1);    // Show Attack
}
