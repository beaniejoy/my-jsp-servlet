package beanie.crawling;

import java.io.IOException;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import beanie.dao.CrawlingDao;
import beanie.dto.CrawlingDto;

public class CrawlingData {

	public static void dataUpdate() {
		int cYear = 2019;
		while (cYear >= 2013) {
			StringBuffer startDate = new StringBuffer();
			StringBuffer endDate = new StringBuffer();

			endDate.append(cYear);
			endDate.append("12");
			endDate.append("19");
			cYear -= 2;
			startDate.append(cYear);
			startDate.append("12");
			startDate.append("19");
			
			String url = "https://coinmarketcap.com/currencies/ethereum/historical-data/?start=" + startDate.toString()
					+ "&end=" + endDate.toString();
			Document doc = null;

			try {
				doc = Jsoup.connect(url).get();

				CrawlingDao dao = CrawlingDao.getInstance();

				Elements elements = doc.select(".cmc-table__table-wrapper-outer table tbody tr");

				for (int i = 0; i < elements.size(); i++) {
					Element trElement = elements.get(i);
					// yyyy-MM-dd 형식으로 string 변환
					String date = DateFormChange.changeDate(trElement.child(0).text().trim());
					// 중복된 데이터가 존재할 시 continue로 넘김
					if(dao.isThere(date)) {
						continue;
					}
					double open = Double.parseDouble(trElement.child(1).text().trim().replace(",", ""));
					double high = Double.parseDouble(trElement.child(2).text().trim().replace(",", ""));
					double low = Double.parseDouble(trElement.child(3).text().trim().replace(",", ""));
					double close = Double.parseDouble(trElement.child(4).text().trim().replace(",", ""));
					long volume = Long.parseLong(trElement.child(5).text().trim().replace(",", ""));
					long cap = Long.parseLong(trElement.child(6).text().trim().replace(",", ""));
					CrawlingDto dto = new CrawlingDto(date, open, high, low, close, volume, cap);
					dao.insert(dto);
				}

			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public static void newDataUpdate() {

	}
}