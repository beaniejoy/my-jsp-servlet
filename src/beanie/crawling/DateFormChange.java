package beanie.crawling;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class DateFormChange {
	
	public static String changeDate(String us){
		String changeDate = null;
		
		SimpleDateFormat in = new SimpleDateFormat("MMM dd, yyyy", Locale.US);
		SimpleDateFormat out = new SimpleDateFormat("yyyy-MM-dd");
		try {
			// String => Date
			// 지정한 Date Form대로 y,m,d 나눠서 Date로 parsing하겠다.
			Date usDate = in.parse(us);
			
			// Date => String
			changeDate = out.format(usDate);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return changeDate;
	}
}