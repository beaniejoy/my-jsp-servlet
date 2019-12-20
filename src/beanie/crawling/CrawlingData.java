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
		String url = "https://coinmarketcap.com/currencies/bitcoin/historical-data/?start=20130429&end=20191219";
		Document doc = null;
		
		try {
			doc = Jsoup.connect(url).get();
			
			CrawlingDao dao = CrawlingDao.getInstance();
			
			Elements elements = doc.select(".cmc-table__table-wrapper-outer table tbody tr");
			for(int i = 0; i < elements.size(); i++) {
				Element trElement = elements.get(i);
				String date = DateFormChange.changeDate(trElement.child(0).text().trim());
				System.out.println(date);
			}
			
			/*
			for (int i = 0; i < elements.size(); i++) {
				Element trElement = elements.get(i);
				String date = DateFormChange.changeDate(trElement.child(0).text().trim());
				double open = Double.parseDouble(trElement.child(1).text().trim().replace(",",""));
				double high = Double.parseDouble(trElement.child(2).text().trim().replace(",",""));
				double low = Double.parseDouble(trElement.child(3).text().trim().replace(",",""));
				double close = Double.parseDouble(trElement.child(4).text().trim().replace(",",""));
				long volume = Long.parseLong(trElement.child(5).text().trim().replace(",",""));
				long cap = Long.parseLong(trElement.child(6).text().trim().replace(",",""));
				System.out.println(date + ", "+open+", "+high+", "+low+", "+close+", "+volume+", "+cap);
				CrawlingDto dto = new CrawlingDto(date, open, high, low, close, volume, cap);
				dao.insert(dto);
			}*/
			
		} catch(IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void newDataUpdate() {
		
	}
}