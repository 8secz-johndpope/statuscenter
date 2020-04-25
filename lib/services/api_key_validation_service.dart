import 'package:statuspageapp/clients/pages_client.dart';
import 'package:statuspageapp/exceptions/request_exception.dart';
import 'package:statuspageapp/models/api_key_validation_result.dart';
import 'package:statuspageapp/models/page.dart';

class APIKeyValidationService {
  static Future<APIKeyValidationResult> validate(String apiKey) async {
    if (apiKey.length < 10) {
      return new APIKeyValidationResult(
          valid: false, error: 'Invalid API key', apiKey: apiKey);
    }

    try {
      List<Page> pages = await new PagesClient(apiKey).getPages();
      if (pages != null && pages.length >= 1) {
        return new APIKeyValidationResult(
            valid: true, apiKey: apiKey, page: pages[0]);
      }

      return new APIKeyValidationResult(valid: false, error: 'No pages found');
    } on RequestException catch (error) {
      return new APIKeyValidationResult(valid: false, error: error.toString());
    }
  }
}
