package kr.co.hlm.system.management;

import kr.co.hlm.system.helmetstate.HelmetState;
import kr.co.hlm.system.kickboardlocation.KickboardLocation;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Component;

@Log4j2
@Component
public class HelmetLostUtil {
    public boolean helmetLostCalculation(HelmetState helmetState, KickboardLocation kickboardLocation){
        double theta = helmetState.getLongitude() - kickboardLocation.getLongitude();
        double dist = Math.sin(deg2rad(helmetState.getLatitude())) * Math.sin(deg2rad(kickboardLocation.getLatitude()))
                + Math.cos(deg2rad(helmetState.getLatitude())) * Math.cos(deg2rad(kickboardLocation.getLatitude()))
                * Math.cos(deg2rad(theta));

        dist = rad2deg(Math.acos(dist));
        dist *= 60 * 1.1515 * 1609.344;

        log.info("distance : " + dist);

        return !(dist > 20);
    }

    private double deg2rad(double deg) {
        return (deg * Math.PI / 180.0);
    }

    private double rad2deg(double rad) {
        return (rad * 180 / Math.PI);
    }
}
