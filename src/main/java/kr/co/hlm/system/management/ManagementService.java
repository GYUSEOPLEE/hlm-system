package kr.co.hlm.system.management;

import kr.co.hlm.system.helmetstate.HelmetState;
import kr.co.hlm.system.kickboardlocation.KickboardLocation;

public interface ManagementService {
    public void sendHelmetLoss(HelmetState helmetState, KickboardLocation kickboardLocation);
}
