package kr.co.hlm.system.page;

import kr.co.hlm.system.helmet.Helmet;
import kr.co.hlm.system.helmetstate.HelmetState;
import kr.co.hlm.system.kickboard.Kickboard;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class HelmetStatePageUtil {
    private static final int PAGE_SIZE = 5;
    private static final int ROW_SIZE = 5;

    public Page setPage(String parasolId ,int totallRowCount, int pageNo) {
        Page page = new Page();
        page.setId(parasolId);
        page.setTotalRowCount(totallRowCount);
        page.setFinalPageNo(this.getFinalPageNo(totallRowCount));
        page.setStartPageNo(this.getStartPage(pageNo));
        page.setEndPageNo(this.getEndPage(page.getStartPageNo(), page.getFinalPageNo()));
        page.setPageNo(pageNo);
        page.setStartRn(this.getStartRn(pageNo));
        page.setEndRn(this.getEndRn(pageNo));
        return page;
    }

    //값시작 인덱스
    private int getStartRn(int pageNo) {
        return (pageNo - 1) * ROW_SIZE;
    }

    //끝나는 인덱스
    private int getEndRn(int pageNo) {
        return pageNo * ROW_SIZE;
    }

    //전체 목록이 끝났는지 여부
    private int getFinalPageNo(int totallRowCount) {
        return totallRowCount % ROW_SIZE != 0
                ? totallRowCount / ROW_SIZE + 1
                : totallRowCount / ROW_SIZE;
    }

    //페이징 시작 넘버링
    private int getStartPage(int pageNo) {
        return ((pageNo - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
    }

    //페이징 끝남 넘버링
    private int getEndPage(int startPage, int finalPage) {
        int endPage = startPage + PAGE_SIZE - 1;

        if (endPage > finalPage) {
            endPage = finalPage;
        }

        return endPage;
    }

    //드로우
    public String drawPage(Page page, List<HelmetState> helmetStateList) {
        StringBuilder drawPage = new StringBuilder();

        if (helmetStateList.size() > 0) {
            drawPage.append("    <section id=\"compared-properties\" class=\"py-0\" style=\"height: 250px\">");
            drawPage.append("            <div class=\"ts-compare-items-table\" >");
            drawPage.append("                <section id=\"details\">");
            drawPage.append("                    <div class=\"row\">");
            drawPage.append("                        <div class=\"col ts-row-title text-center\">번호</div>");
            drawPage.append("                        <div class=\"col ts-row-title text-left\">일련번호</div>");
            drawPage.append("                        <div class=\"col ts-row-title text-left\">일시</div>");
            drawPage.append("                        <div class=\"col ts-row-title text-left\">위도</div>");
            drawPage.append("                        <div class=\"col ts-row-title text-left\">경도</div>");
            drawPage.append("                        <div class=\"col ts-row-title text-left\">분실여부</div>");
            drawPage.append("                        <div class=\"col ts-row-title text-left\">착용여부</div>");
            drawPage.append("                    </div>");

            for (int i = 0; i < helmetStateList.size(); i++) {
                drawPage.append("<div class=\"row\">");
                drawPage.append("    <div class=\"col text-center\">").append(page.getTotalRowCount() - (i + ((page.getPageNo() - 1) * 5))).append("</div>");
                drawPage.append("    <div class=\"col text-left\">").append(helmetStateList.get(i).getHelmetNo()).append("</div>");
                drawPage.append("    <div class=\"col text-left\">").append(helmetStateList.get(i).getDateTime()).append("</div>");
                drawPage.append("    <div class=\"col text-left\">").append(helmetStateList.get(i).getLongitude()).append("</div>");
                drawPage.append("    <div class=\"col text-left\">").append(helmetStateList.get(i).getLatitude()).append("</div>");
                drawPage.append("    <div class=\"col text-left\">").append(helmetStateList.get(i).getLoss()).append("</div>");
                drawPage.append("    <div class=\"col text-left\">").append(helmetStateList.get(i).getWear()).append("</div>");
                drawPage.append("</div>");
            }

            drawPage.append("                </section>");
            drawPage.append("        </div>");
            drawPage.append("    </section>");

            drawPage.append("    <section id=\"pagination\">");
            drawPage.append("        <div class=\"container\">");
            drawPage.append("            <nav aria-label=\"Page navigation\">");
            drawPage.append("                <ul class=\"pagination ts-center__horizontal\">");
            drawPage.append("                    <ul class=\"pagination ts-center__horizontal col-3\">");

            if (page.getStartPageNo() != 1) {
                drawPage.append("<li class=\"page-item\">");
                drawPage.append("    <a class=\"page-link border ts-btn-arrow\" href=\"javascript:void(0);\" onclick=\"pageOver(" + 1 + ")\">처음</a>");
                drawPage.append("</li>");
                if ((page.getStartPageNo() - 25) > 0) {
                    drawPage.append("<li class=\"page-item\">");
                    drawPage.append("    <a class=\"page-link border ts-btn-arrow\" href=\"javascript:void(0);\" onclick=\"pageOver(").append(page.getEndPageNo() - (PAGE_SIZE * 5)).append(")\">-5</a>");
                    drawPage.append("</li>");
                }
                drawPage.append("<li class=\"page-item\">");
                drawPage.append("    <a class=\"page-link border ts-btn-arrow\" href=\"javascript:void(0);\" onclick=\"pageOver(").append(page.getStartPageNo() - 1).append(")\">이전</a>");
                drawPage.append("</li>");
            }

            drawPage.append("                    </ul>");
            drawPage.append("                    <ul class=\"pagination ts-center__horizontal col-4\">");

            for (int i = page.getStartPageNo(); i <= page.getEndPageNo(); i++) {
                if (i == page.getPageNo()) {
                    drawPage.append("<li class=\"page-item active\">");
                    drawPage.append("    <a class=\"page-link\" href=\"javascript:void(0);\" onclick=\"pageOver(").append(i).append(")\">").append(i).append("</a>");
                    drawPage.append("</li>");
                } else {
                    drawPage.append("<li class=\"page-item\">");
                    drawPage.append("    <a class=\"page-link\" href=\"javascript:void(0);\" onclick=\"pageOver(").append(i).append(")\">").append(i).append("</a>");
                    drawPage.append("</li>");
                }
            }

            drawPage.append("                    </ul>");
            drawPage.append("                    <ul class=\"pagination ts-center__horizontal col-3\">");

            if (page.getEndPageNo() != page.getFinalPageNo()) {
                drawPage.append("<li class=\"page-item\">");
                drawPage.append("    <a class=\"page-link border ts-btn-arrow\" href=\"javascript:void(0);\" onclick=\"pageOver(").append(page.getEndPageNo() + 1).append(")\">다음</a>");
                drawPage.append("</li>");

                if ((page.getStartPageNo() + 25) < page.getFinalPageNo()) {
                    drawPage.append("<li class=\"page-item\">");
                    drawPage.append("    <a class=\"page-link border ts-btn-arrow\" href=\"javascript:void(0);\" onclick=\"pageOver(").append(page.getStartPageNo() + (PAGE_SIZE * 5)).append(")\">+5</a>");
                    drawPage.append("</li>");
                }

                drawPage.append("<li class=\"page-item\">");
                drawPage.append("    <a class=\"page-link border ts-btn-arrow\" href=\"javascript:void(0);\" onclick=\"pageOver(").append(page.getFinalPageNo()).append(")\">마지막</a>");
                drawPage.append("</li>");
            }

            drawPage.append("                    </ul>");
            drawPage.append("                </ul>");
            drawPage.append("            </nav>");
            drawPage.append("        </div>");
            drawPage.append("    </section>");
        } else {
            drawPage.append("<section>");
            drawPage.append("    <div class=\"container\">");
            drawPage.append("        <div class=\"ts-compare-items-table\">");
            drawPage.append("            <section id=\"details\">");
            drawPage.append("                <h1>상태 정보가 없습니다.</h4>");
            drawPage.append("            </section>");
            drawPage.append("        </div>");
            drawPage.append("    </div>");
            drawPage.append("</section>");
        }

        return drawPage.toString();
    }
}
