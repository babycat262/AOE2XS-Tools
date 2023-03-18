const int unitShooter = 1577;

const int projBullet = 380;
const int projInvisible = 322;
const int projInvisible_clone = 321;
const int projInvisible_dyingFrame = 4;
const int playerNumber_1p = 1;

int frameCount = 0;
int frameRate = 0;

int frameCount_bullet = 0;
int magCapacity = 5;
int magCurrent = 0;
bool bulletbool = false;

void main() {

    magCurrent = magCapacity;

    xsEffectAmount(cSetAttribute, unitShooter, cAttack, 0, playerNumber_1p);
    xsEffectAmount(cSetAttribute, unitShooter, cMaxCharge, magCurrent, playerNumber_1p);
    xsEffectAmount(cSetAttribute, unitShooter, cProjectileUnit, projBullet, playerNumber_1p);
    xsEffectAmount(cSetAttribute, unitShooter, cSecondaryProjectileUnit, projInvisible, playerNumber_1p);
    xsEffectAmount(cSetAttribute, unitShooter, cMaxTotalProjectiles, magCurrent+1, playerNumber_1p);
    xsEffectAmount(cSetAttribute, unitShooter, cTotalProjectiles, magCurrent+1, playerNumber_1p);
    xsEffectAmount(cSetAttribute, unitShooter, cCombatAbility, 16, playerNumber_1p);

    xsEffectAmount(cSetAttribute, projBullet, cMovementSpeed, 10, playerNumber_1p);
    xsEffectAmount(cSetAttribute, projBullet, cBloodUnitId, 1223, playerNumber_1p);
    xsEffectAmount(cSetAttribute, 1223, cHitpoints, 0, playerNumber_1p);
    xsEffectAmount(cSetAttribute, projInvisible, cMovementSpeed, 0, playerNumber_1p);
    xsEffectAmount(cSetAttribute, projInvisible, cBlastAttackLevel, 5, playerNumber_1p);

    xsEffectAmount(cUpgradeUnit, projInvisible_clone, projInvisible, 0, playerNumber_1p);
    xsEffectAmount(cSetAttribute, projInvisible_clone, cHitpoints, 0, playerNumber_1p);

}

rule frameRule1
    active
    highFrequency
    priority 0
{
    frameCount++;
}

rule frameRule2
    active
    minInterval 1
    maxInterval 1
    priority 1
{
    // xsChatData("current frame : " + frameCount);
    frameRate = frameCount;
    frameCount = 0;
}

rule bulletCheck
    active
    group bulletRules
    highFrequency
    priority 2
{
    frameCount_bullet++;
    switch(frameCount_bullet%projInvisible_dyingFrame) {
        case 0 : {
            if (xsGetObjectCount(1, projInvisible) > 0) {
                bulletbool = true;
                magCurrent--;
                xsEffectAmount(cSetAttribute, unitShooter, cTotalProjectiles, magCurrent+1, playerNumber_1p);
                xsEffectAmount(cSetAttribute, projInvisible, cHitpoints, 0, 1);
                xsEffectAmount(cSetAttribute, unitShooter, cRechargeRate, -1.01 * frameRate, playerNumber_1p);
            }
        }
        case 1 : {
            if (bulletbool) {
                bulletbool = false;
                xsEffectAmount(cSetAttribute, projInvisible, cHitpoints, 1, playerNumber_1p);
                xsEffectAmount(cSetAttribute, unitShooter, cRechargeRate, 0, playerNumber_1p);
            }
            if (magCurrent == 0)
            {
                if (xsGetObjectCount(1, projBullet) == 0) {
                    xsEffectAmount(cSetAttribute, unitShooter, cProjectileUnit, projInvisible_clone, playerNumber_1p);
                    xsEffectAmount(cSetAttribute, unitShooter, cMinimumRange, 11, playerNumber_1p);
                    xsEffectAmount(cSetAttribute, unitShooter, cMaxRange, 0, playerNumber_1p);
                    xsEffectAmount(cSetAttribute, unitShooter, cShownRange, 0, playerNumber_1p);
                    xsEffectAmount(cSetAttribute, unitShooter, cAttackReloadTime, 10000, playerNumber_1p);
                }
            }
        }
        default : {}
    }
}
