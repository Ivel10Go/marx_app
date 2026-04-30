# Affiliate Program Integration Guide

## Overview
The Marx app can monetize through affiliate partnerships with educational platforms. This guide covers integration with Amazon Associates and Udemy Partner Program for course recommendations and resource links.

## Prerequisites
- Affiliate accounts (Amazon Associates, Udemy Partner Program)
- Basic understanding of affiliate marketing
- Website/app for affiliate link placement
- Banking information for payment

## Phase 1: Affiliate Program Setup

### 1.1 Amazon Associates Program

**Signup Process:**
1. Visit [Amazon Associates](https://affiliate-program.amazon.com)
2. Click "Join Now"
3. Enter account information
4. Select apps/websites to promote
5. Accept operating agreement
6. Wait for approval (24-72 hours)

**After Approval:**
1. Dashboard → Stores
2. Select "Stores" → "Create a store"
3. Choose product categories for recommendations
4. Generate affiliate links

### 1.2 Udemy Partner Program

**Signup Process:**
1. Visit [Udemy Affiliate Program](https://teach.udemy.com/affiliate-program)
2. Sign in with Udemy account (or create new)
3. Apply for partner program
4. Provide details:
   - Website/app name: `Marx App`
   - Traffic source: `In-app recommendations`
   - Marketing methods: `Course recommendations`
5. Accept terms and conditions

**After Approval:**
1. Dashboard → Affiliate Tools
2. Generate API credentials
3. Setup tracking parameters
4. Create custom links

### 1.3 Other Programs (Optional)

| Program | URL | Commission | Requirements |
|---------|-----|-----------|--------------|
| Skillshare | skillshare.com/r | 20% | Traffic requirement |
| Coursera | coursera.org/partner | Variable | High traffic |
| Google Play Apps | play.google.com | 30% | Merchant account |

## Phase 2: Link Generation

### 2.1 Amazon Associates Links

**Structure:**
```
https://amazon.com/s?k=SEARCH_TERM&tag=YOUR_TAG-20
```

**Example - Python Book:**
```
https://amazon.com/s?k=python+programming&tag=marxapp0c-20
```

**Parameters:**
- `tag`: Your tracking ID (format: `yoursite-20`)
- `k`: Search keywords

### 2.2 Udemy Affiliate Links

**Structure:**
```
https://www.udemy.com/course/COURSE-SLUG/?referralCode=YOUR_CODE
```

**Example - Python Course:**
```
https://www.udemy.com/course/complete-python-bootcamp/?referralCode=ABC123XYZ
```

**Parameters:**
- `course`: Course identifier
- `referralCode`: Your unique referral code

### 2.3 Tracking Parameters

**Recommended Parameters:**
```
?utm_source=marx_app
&utm_medium=in_app
&utm_campaign=CAMPAIGN_NAME
&utm_content=CONTENT_TYPE
```

**Full Example:**
```
https://www.udemy.com/course/python-course/?
  referralCode=ABC123
  &utm_source=marx_app
  &utm_medium=recommended_courses
  &utm_campaign=programming_bundle
```

## Phase 3: Flutter Integration

### 3.1 Create Affiliate Service
`lib/services/affiliate_service.dart`:
```dart
class AffiliateService {
  // Amazon Associates
  static const String amazonAssociatesTag = 'marxapp0c-20';
  
  // Udemy
  static const String udemyReferralCode = 'YOUR_UDEMY_CODE';
  
  // Skillshare (optional)
  static const String skillshareReferralLink = 'https://skillshare.com/r/user/YOUR_ID';
  
  static String generateAmazonLink({
    required String searchTerm,
    String? category,
  }) {
    final encodedTerm = Uri.encodeComponent(searchTerm);
    final baseUrl = 'https://amazon.com/s?k=$encodedTerm&tag=$amazonAssociatesTag';
    
    if (category != null) {
      return '$baseUrl&i=$category';
    }
    return baseUrl;
  }
  
  static String generateUdemyLink({
    required String courseSlug,
    String? campaign = 'app_recommendation',
  }) {
    return 'https://www.udemy.com/course/$courseSlug/'
        '?referralCode=$udemyReferralCode'
        '&utm_source=marx_app'
        '&utm_medium=in_app'
        '&utm_campaign=$campaign';
  }
  
  static String generateSkillshareLink({
    String? campaign = 'app_recommendation',
  }) {
    return '$skillshareReferralLink'
        '?utm_source=marx_app'
        '&utm_campaign=$campaign';
  }
}
```

### 3.2 Add URL Launcher Package
```bash
flutter pub add url_launcher
```

`pubspec.yaml`:
```yaml
dependencies:
  url_launcher: ^6.1.0
```

### 3.3 Create Link Handler Widget
`lib/widgets/affiliate_link_widget.dart`:
```dart
import 'package:url_launcher/url_launcher.dart';
import '../services/affiliate_service.dart';

class AffiliateLinkWidget extends StatelessWidget {
  final String title;
  final String description;
  final String link;
  final String source; // 'amazon', 'udemy', 'skillshare'
  final VoidCallback? onTap;
  
  const AffiliateLinkWidget({
    required this.title,
    required this.description,
    required this.link,
    required this.source,
    this.onTap,
  });
  
  Future<void> _openLink() async {
    if (onTap != null) {
      onTap!();
    }
    
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(
        Uri.parse(link),
        mode: LaunchMode.externalApplication,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openLink,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getSourceColor(source),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.open_in_new,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Tap to visit ${_getSourceName(source)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getSourceColor(String source) {
    switch (source.toLowerCase()) {
      case 'amazon':
        return Colors.orange;
      case 'udemy':
        return const Color(0xFF2D3436);
      case 'skillshare':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  
  String _getSourceName(String source) {
    switch (source.toLowerCase()) {
      case 'amazon':
        return 'Amazon';
      case 'udemy':
        return 'Udemy';
      case 'skillshare':
        return 'Skillshare';
      default:
        return 'Site';
    }
  }
}
```

## Phase 4: Placement Strategies

### 4.1 Course Resource Section
Placement: Course details page, bottom section
```dart
Column(
  children: [
    Text('Recommended Resources'),
    AffiliateLinkWidget(
      title: 'Complete Python Programming Bundle',
      description: 'Comprehensive guide to Python from basics to advanced',
      link: AffiliateService.generateUdemyLink(courseSlug: 'complete-python-bootcamp'),
      source: 'udemy',
      onTap: () => _trackAffiliateClick('python_bundle'),
    ),
  ],
)
```

### 4.2 Learning Path Resources
Placement: Learning path completion page
```dart
Text('Enhance Your Learning:'),
AffiliateLinkWidget(
  title: 'Python Books & Resources',
  description: 'Top-rated programming books on Amazon',
  link: AffiliateService.generateAmazonLink(
    searchTerm: 'Python Programming',
    category: 'books',
  ),
  source: 'amazon',
  onTap: () => _trackAffiliateClick('python_books'),
),
```

### 4.3 Settings/Resources Tab
Placement: New "Resources" or "Learning Hub" section
- Curated course recommendations
- Books and tutorials
- Tools and software links

## Phase 5: Analytics & Tracking

### 5.1 Track Affiliate Clicks
`lib/services/analytics_service.dart`:
```dart
class AnalyticsService {
  static Future<void> trackAffiliateClick({
    required String program,
    required String source,
    required String campaignName,
  }) async {
    // Firebase Analytics
    FirebaseAnalytics.instance.logEvent(
      name: 'affiliate_click',
      parameters: {
        'program': program,
        'source': source,
        'campaign': campaignName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    // Local Analytics Database
    await affiliateClicksDb.insert(
      'clicks',
      {
        'program': program,
        'source': source,
        'campaign': campaignName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
```

### 5.2 Dashboard Query
```dart
Future<int> getAffiliateClicksToday() async {
  final today = DateTime.now().toIso8601String().split('T').first;
  final result = await db.rawQuery(
    'SELECT COUNT(*) as count FROM clicks WHERE timestamp LIKE ?',
    ['$today%'],
  );
  return result.first['count'] as int;
}
```

## Phase 6: Compliance & Disclosure

### 6.1 Affiliate Disclosure in UI
Add to app settings or about page:
```dart
Text('Affiliate Disclosure'),
Text(
  'This app contains affiliate links. When you click on an affiliate link and make a purchase, '
  'we may earn a commission at no additional cost to you. '
  'This helps support the development of the app.',
  style: Theme.of(context).textTheme.bodySmall,
),
```

### 6.2 Privacy Policy Updates
Add to privacy policy:
```
Affiliate Links and Monetization

We use affiliate links in this app to recommend products and courses from:
- Amazon Associates
- Udemy Partner Program
- Other educational platforms

When you click these links and make a purchase, we may earn a commission.
This does not affect your purchase price and helps fund app development.
```

### 6.3 Terms & Conditions
Include:
- Affiliate relationship disclosure
- No endorsement of products
- User's right to disable recommendations
- Cookie/tracking disclosure

## Phase 7: Performance Monitoring

### 7.1 Affiliate Revenue Tracking
```dart
class AffiliateRevenueService {
  static Future<Map<String, dynamic>> getMonthlyRevenue() async {
    final result = await affiliateDb.rawQuery('''
      SELECT 
        program,
        COUNT(*) as clicks,
        SUM(earnings) as total_earnings
      FROM affiliate_earnings
      WHERE DATE(date) BETWEEN DATE('now', '-30 days') AND DATE('now')
      GROUP BY program
    ''');
    
    return Map.fromEntries(
      result.map((row) => MapEntry(
        row['program'] as String,
        row,
      )),
    );
  }
}
```

### 7.2 Monitor Conversion Rate
- Track clicks vs. conversions
- Analyze which programs perform best
- Optimize link placement
- Test different call-to-actions

## Phase 8: Best Practices

### 8.1 Link Placement Strategy
✓ **DO:**
- Place links near relevant content
- Use clear, descriptive titles
- Disclose affiliate relationship
- Only recommend quality products
- Track clicks for analytics

✗ **DON'T:**
- Place too many links
- Make deceptive recommendations
- Hide affiliate disclosure
- Recommend low-quality products
- Force users to click

### 8.2 Call-to-Action Examples
```
"Learn more with this Udemy course"
"Find tools and books on Amazon"
"Explore more on Skillshare"
"Get the full resource guide"
```

### 8.3 Timing & Context
- Show after course completion
- In resource sections
- Related to course content
- Optional (not forced)
- When user is engaged

## Phase 9: Troubleshooting

### Issue: Affiliate links not tracking
**Solution:**
- Verify tracking parameters included
- Check affiliate dashboard for attribution
- Ensure proper deep linking setup
- Verify UTM parameters correct

### Issue: Low conversion rates
**Solution:**
- Review link placement
- Test different call-to-actions
- Analyze user behavior
- Target relevant content
- Monitor competitor strategies

### Issue: Payment not received
**Solution:**
- Verify minimum payout threshold reached
- Check payment method on file
- Confirm affiliate status active
- Review affiliate account dashboard
- Contact support

## Phase 10: Expansion Opportunities

- **LinkedIn Learning**: Professional courses
- **Pluralsight**: Tech skill development
- **Coursera**: University-level courses
- **MasterClass**: Celebrity instructors
- **Skillshare**: Creative skills
- **eBook Publishers**: Technical books
- **Coding Bootcamps**: Intensive programs

## References
- [Amazon Associates Program](https://affiliate-program.amazon.com)
- [Udemy Affiliate Program](https://teach.udemy.com/affiliate-program)
- [URL Launcher Package](https://pub.dev/packages/url_launcher)
- [FTC Endorsement Guidelines](https://www.ftc.gov/news-events/audio-podcast-0)
- [Affiliate Marketing Best Practices](https://www.forbes.com/advisor/business/affiliate-marketing)
