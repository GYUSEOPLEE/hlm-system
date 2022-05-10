package kr.co.hlm.system.kickboard;

import java.util.List;

public interface KickboardService {
    public void createKickboard(Kickboard kickboard);
    public List<Kickboard> getKickboards(Kickboard kickboard);
    public Kickboard getKickboard(Kickboard kickboard);
    public void editKickboard(Kickboard kickboard);

}
