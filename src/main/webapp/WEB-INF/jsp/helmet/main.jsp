<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <%@ include file="/WEB-INF/jsp/include/head.jsp" %>
        <script src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=2fxsselz7s"></script>

        <title>공유 킥보드 헬멧 관리 시스템 - 메인</title>

        <style>
            #tableSetting {
                border-right: 1px solid #444444;
            }
        </style>
    </head>
    <body style="font-family: 'Noto Sans KR', sans-serif;">



        <section id="ts-hero" class=" mb-0">
            <div class="ts-full-screen d-flex flex-column">
                <section class="ts-shadow__sm ts-z-index__2 ts-bg-light">
                    <%@ include file="/WEB-INF/jsp/include/header.jsp" %>
                    <br>
                    <br>
                    <br>
                    <br>
                    <br>
<%--                    검색 라인 감추기 버튼--%>
<%--                    <div class="position-absolute w-100 ts-bottom__0 ts-z-index__1 text-center ts-h-0">--%>
<%--                        <button type="button" class="ts-circle p-3 bg-white ts-shadow__sm border-0 ts-push-up__50 mt-2" data-toggle="collapse" data-target="#form-collapse">--%>
<%--                            <i class="fa fa-chevron-up ts-text-color-primary ts-visible-on-uncollapsed"></i>--%>
<%--                            <i class="fa fa-chevron-down ts-text-color-primary ts-visible-on-collapsed"></i>--%>
<%--                        </button>--%>
<%--                    </div>--%>

<%--                검색 라인--%>
                    <div id="form-collapse" class="collapse ts-xs-hide-collapse show">
                        <div class="ts-form mb-0 d-flex flex-column flex-sm-row py-2 pl-2 pr-3">
                            <div class="form-group m-1 w-100">
                                <input type="text" class="form-control" id="keyword" name="managementNo" placeholder="헬멧 일련번호 or 모델명" />
                            </div>
                            <div class="form-group m-1 w-100">
                                <select class="custom-select" id="type" name="activation">
                                    <option value="X">전체</option>
                                    <option value="Y">활성</option>
                                    <option value="N">비활성</option>
                                </select>
                            </div>
                            <div class="form-group m-1 ml-auto">
                                <button type="button" class="btn btn-primary" id="search-btn">검색</button>
                            </div>
                        </div>
                    </div>
                </section>

                <div class="d-flex h-100">
                    <div class="ts-results__vertical ts-results__vertical-list ts-shadow__sm scrollbar-inner bg-white">
                        <section id="ts-results">
                            <div id="drawResult"  class="ts-results-wrapper" style="overflow: auto"></div>
                        </section>
                    </div>
                    <div class="ts-map w-100">
                        <div class="ts-map w-100">
                            <div id="map" class="h-100"></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
    <script>
        search();
        let dataToJson;
        let mapOptions = {
            zoom: 9
        };
        let map = new naver.maps.Map('map', mapOptions);
        let markers = [];
        let infowindows = [];
        function search() {
            searchXmlHttpRequest = new XMLHttpRequest();
            searchXmlHttpRequest.open("POST", "/helmets/main", true);
            searchXmlHttpRequest.setRequestHeader("Content-Type","application/json;charset=UTF-8");
            searchXmlHttpRequest.send('{"no" : "' + document.getElementById("keyword").value + '", "activation" : "' + document.getElementById("type").value + '"}');
            searchXmlHttpRequest.onreadystatechange = getData;
        }
        function getData() {
            if (searchXmlHttpRequest.readyState == 4 && searchXmlHttpRequest.status == 200) {
                dataToJson = JSON.parse(searchXmlHttpRequest.responseText);
            }
            if (markers.length > 0) {
                for (var i = 0; i < markers.length; i ++) {
                    markers[i].setMap(null);
                    infowindows[i].setMap(null);
                }
                infowindows = [];
                markers = [];
            }
            if (dataToJson != null) {
                if (dataToJson.length > 0) {
                    var script = "";
                    for (var i = 0; i < dataToJson.length; i++) {
                        let no = dataToJson[i].no;
                        let dateTime = dataToJson[i].dateTime;
                        let latitude = dataToJson[i].latitude;
                        let longitude = dataToJson[i].longitude;
                        let activation = dataToJson[i].activation;
                        let loss = dataToJson[i].loss;
                        let wear = dataToJson[i].wear;
                        let activationKr = "";
                        let color;

                        if (activation == "Y") {
                            activationKr = "활성"
                        } else {
                            activationKr = "비활성"
                            color = "text-danger";
                        }
                            script += '<div class="ts-result-link card ts-item ts-card ts-result" data-ts-id="6" data-ts-ln="5" >'
                                + '    <a href="javascript:void(0);" onclick="moveMap(' + latitude + ', ' + longitude + ', ' + i + ')">'
                                + '        <input type="hidden" id="no' + i + '" value="' + no + '" />'
                                + '        <input type="hidden" id="dateTime' + i + '" value="' + dateTime + '" />'
                                + '        <input type="hidden" id="latitude' + i + '" value="' + latitude + '" />'
                                + '        <input type="hidden" id="longitude' + i + '" value="' + longitude + '" />'
                                + '        <input type="hidden" id="activation' + i + '" value="' + activation + '" />'
                                + '        <input type="hidden" id="loss' + i + '" value="' + loss + '" />'
                                + '        <input type="hidden" id="wear' + i + '" value="' + wear + '" />'
                                + '        <input type="hidden" id="activationKr' + i + '" value="' + activationKr + '" />'

                                + '        <table>'
                                + '             <tr>'
                                + '                 <td id="tableSetting">' + (i+1) + '</td>'
                                + '                 <td>'
                                + '                     <div class="card-body">'
                                + '                         <figure class="ts-item__info">'
                                + '                             <h3>' + no + '</h3>'
                                + '                             <aside class="' + color + '" style="font-size: 1em">'
                                + '                                 <i class="fa fa-map-marker mr-2"></i>'
                                +                                   activationKr
                                + '                             </aside>'
                                + '                         </figure>'
                                + '                     </div>'
                                + '                 </td>'
                                + '             </tr>'
                                + '        </table>'

                                // + '        <div class="card-body">'
                                // + '            <figure class="ts-item__info">'
                                // + '                <h3>' + managementNo + '</h3>'
                                // + '                <aside class="' + color + '" style="font-size: 1em">'
                                // + '                    <i class="fa fa-map-marker mr-2"></i>'
                                // +                      activationKr
                                // + '                </aside>'
                                // + '            </figure>'
                                // + '        </div>'
                                + '    </a>'
                                + '</div>';
                    }
                    document.getElementById("drawResult").innerHTML = script;
                    for (var i = 0; i < dataToJson.length; i++) {
                        let statusKr;
                        let color;
                        //마커 색
                        if (document.getElementById("activation" + i).value == "N") {
                            color = "rgb(234,9,9)";
                        } else {
                            color = "rgb(5,148,252)";
                        }

                        //마커 상태
                        if (document.getElementById("status" + i).value == "펼침") {
                            statusKr = "접기";
                        } else {
                            statusKr = "펼치기";
                        }

                        //마커 하나하나 위치
                        var marker = new naver.maps.Marker({
                            position: new naver.maps.LatLng(document.getElementById("latitude" + i).value, document.getElementById("longitude" + i).value),
                            map: map,
                            animation: naver.maps.Animation.DROP
                        });

                        //마커 윈도우 정보
                        var contentString = [
                            // '<section style="margin: auto; width: fit-content" class="mb-1 pl-0">'
                            // + '    <input type="hidden" id="contentString" value="' + i + '" />'
                            // + '    <div class="mb-2 card ts-item ts-card ts-result" data-toggle="tooltip" data-placement="right" title="상세 정보 보기">'
                            // + '        <a style="text-align: center; width: 100%; font-size: 1.5em" href="/parasol/' + document.getElementById("id" + i).value + '">' + document.getElementById("managementNo" + i).value + '</a>'
                            // + '    </div>'
                            // + '    <div style="text-align: center; margin: auto" class="row">'
                            // + '        <div class="col-sm-4">'
                            // + '            <label>활성</label>'
                            // + '            <p>' + document.getElementById("activation" + i).value + '</p>'
                            // + '        </div>'
                            // + '        <div class="col-sm-4">'
                            // + '            <label>상태</label>'
                            // + '            <p id="infoStatus' + i + '">' + document.getElementById("status" + i).value + '</p>'
                            // + '        </div>'
                            // + '        <div class="col-sm-4">'
                            // + '            <label>온도</label>'
                            // + '            <p id="infoTemperature' + i + '">' + document.getElementById("temperature" + i).value + '℃</p>'
                            // + '        </div>'
                            // + '        <div class="col-sm-12 mb-0 mb-sm-0 btn-sm d-block d-sm-inline-block">'
                            // + '            <label>일시</label>'
                            // + '            <p id="infoDateTime' + i + '">' + document.getElementById("dateTime" + i).value + '</p>'
                            // + '        </div>'
                            // + '        <div class="col-sm-12 mb-1">'
                            // + '           <a href="javascript:void(0);" id="actionButton' + i + '" onclick="sendAction(document.getElementById(`id' + i + '`).value, document.getElementById(`action' + i + '`).value, ' + i + ');" class="btn btn-primary">' + statusKr + '</a>'
                            // + '        </div>'
                            // + '    </div>'
                            // + '</section>'
                        ].join('');

                        //마커 윈도우
                        var infowindow = new naver.maps.InfoWindow({
                            content: contentString,
                            maxWidth: 200,
                            backgroundColor: "rgb(214,250,223)",
                            borderColor: color,
                            borderWidth: 3,
                            anchorSize: new naver.maps.Size(10, 10),
                            anchorSkew: true,
                            anchorColor: "rgb(214,250,223)",
                            pixelOffset: new naver.maps.Point(20, -20)
                        });

                        //naver.maps.Event.addListener(marker, 'click', markerClick(i));
                        markers.push(marker);
                        infowindows.push(infowindow);
                    }
                } else {
                    document.getElementById("drawResult").innerHTML = '<div class="ts-result-link " data-ts-id="6" data-ts-ln="5">'
                        + '    <p class="card ts-item ts-card ts-result">'
                        + '        <div class="card-body">'
                        + '            <figure class="ts-item__info">'
                        + '                <h4 class="text-center">검색 결과가 없습니다</h4>'
                        + '            </figure>'
                        + '        </div>'
                        + '    </p>'
                        + '</div>';
                }
            }
        }
        function responseBysendAction() {
            if (actionXmlHttpRequest.readyState == 4 && actionXmlHttpRequest.status == 200) {
                code = JSON.parse(actionXmlHttpRequest.responseText);
                console.log(code);
            }
            if (document.getElementById("contentString").value == indexI) {
                receiveStatus(indexI);
            }
        }
        function receiveStatus(indexI) {
            StatusXmlHttpRequest = new XMLHttpRequest();
            StatusXmlHttpRequest.open("GET", "/helmetstates/" + document.getElementById("no" + indexI).value + "/info", true);
            StatusXmlHttpRequest.setRequestHeader("Content-Type","application/json;charset=UTF-8");
            StatusXmlHttpRequest.send();
            StatusXmlHttpRequest.onreadystatechange = function () {
                if (StatusXmlHttpRequest.readyState == 4 && StatusXmlHttpRequest.status == 200) {
                    parasolStatus = JSON.parse(StatusXmlHttpRequest.responseText);
                    shiftElement(parasolStatus, indexI);
                }
            }
        }

        //마커 값 변경
        // function shiftElement(parasolStatus, indexI) {
        //     document.getElementById("status" + indexI).setAttribute('value', parasolStatus.status);
        //     document.getElementById("temperature" + indexI).setAttribute('value', parasolStatus.temperature);
        //     document.getElementById("dateTime" + indexI).setAttribute('value', parasolStatus.dateTime);
        //     document.getElementById("infoStatus" + indexI).innerText = parasolStatus.status;
        //     document.getElementById("infoTemperature" + indexI).innerText = parasolStatus.temperature;
        //     document.getElementById("infoDateTime" + indexI).innerText = parasolStatus.dateTime;
        //     if (parasolStatus.status == "펼침") {
        //         document.getElementById("action" + indexI).setAttribute('value', "F");
        //         document.getElementById("actionButton" + indexI).innerText = "접기";
        //     } else {
        //         document.getElementById("action" + indexI).setAttribute('value', "U");
        //         document.getElementById("actionButton" + indexI).innerText = "펼치기";
        //     }
        //     document.getElementById("actionButton" + indexI).setAttribute('class', "btn btn-primary");
        // }

        //마커 클릭했을때
        // function markerClick(index) {
        //     return function (e) {
        //         if (markers[index].getAnimation() != null) {
        //             markers[index].setAnimation(null);
        //         } else {
        //             for (var i = 0; i < markers.length; i++) {
        //                 markers[i].setAnimation(null);
        //             }
        //             markers[index].setAnimation(naver.maps.Animation.BOUNCE);
        //         }
        //         if (infowindows[index].getMap()) {
        //             infowindows[index].close();
        //         } else {
        //             receiveStatus(index);
        //             infowindows[index].open(map, markers[index]);
        //         }
        //     }
        // }

        function moveMap(latitude, longitude, index) {
            map.setCenter(new naver.maps.LatLng(latitude, longitude));
            map.setZoom(18);
            // for (var i = 0; i < markers.length; i++) {
            //     if (markers[i].getAnimation() != null) {
            //         markers[i].setAnimation(null);
            //     }
            // }
            // markers[index].setAnimation(naver.maps.Animation.BOUNCE);
            receiveStatus(index);
            infowindows[index].open(map, markers[index]);
        }
        document.getElementById("search-btn").addEventListener("click", search, false);
    </script>

    <%@ include file="/WEB-INF/jsp/include/bottom.jsp" %>
    </body>
</html>