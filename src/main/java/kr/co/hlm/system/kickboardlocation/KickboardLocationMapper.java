package kr.co.hlm.system.kickboardlocation;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface KickboardLocationMapper {
    void insert(KickboardLocation kickboardLocation);
    KickboardLocation select(KickboardLocation kickboardLocation);
}
