# Feature Deep Dive Specification

## Overview
Comprehensive technical specification for core Marx app features, detailing architecture, implementation requirements, and integration patterns.

---

## 1. UI/UX Specifications

### 1.1 Navigation Flow
```
Main Dashboard
├── Browse Features (Grid/List View)
│   ├── Feature Detail Screen
│   │   ├── Overview Tab
│   │   ├── Resources Tab
│   │   └── Related Concepts Tab
│   └── Back to Dashboard
├── Search & Filter
│   ├── Search Results
│   └── Apply Filters (Category, Difficulty, Duration)
└── User Profile
    ├── Settings
    └── Progress Summary
```

### 1.2 Wireframes & Component Hierarchy

**Dashboard Screen Layout:**
```
┌─────────────────────────────────────┐
│ Header: Marx App                    │ (Height: 60px)
├─────────────────────────────────────┤
│ Search Bar (Elevated)               │ (Height: 50px)
├─────────────────────────────────────┤
│ Featured Content Carousel           │ (Height: 200px)
│ • Category 1 | Category 2 | ...     │
├─────────────────────────────────────┤
│ Grid of Feature Cards (2 columns)   │ (Dynamic Height)
│ ┌──────────┐ ┌──────────┐          │
│ │ Feature1 │ │ Feature2 │          │
│ │ [Icon]   │ │ [Icon]   │          │
│ │ Title    │ │ Title    │          │
│ │ ⭐ 4.5   │ │ ⭐ 4.8   │          │
│ └──────────┘ └──────────┘          │
└─────────────────────────────────────┘
```

### 1.3 Color Palette & Typography

**Colors:**
- Primary: #FF6B35 (Energetic Orange)
- Secondary: #004E89 (Deep Blue)
- Accent: #1AC8ED (Cyan)
- Background: #F8F9FA (Light Gray)
- Surface: #FFFFFF (White)
- Error: #E63946 (Red)
- Success: #06D6A0 (Green)

**Typography:**
- Headline1: Size 32, Weight 700, Family: Roboto
- Headline6: Size 18, Weight 600, Family: Roboto
- Body1: Size 14, Weight 400, Family: Roboto
- Caption: Size 12, Weight 400, Family: Roboto

---

## 2. Database Schema

### 2.1 Core Tables

```sql
CREATE TABLE features (
    id TEXT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category_id VARCHAR(100),
    difficulty_level ENUM('Beginner', 'Intermediate', 'Advanced'),
    estimated_duration_minutes INT,
    icon_url VARCHAR(500),
    thumbnail_url VARCHAR(500),
    is_active BOOLEAN DEFAULT true,
    version INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE feature_content (
    id TEXT PRIMARY KEY,
    feature_id VARCHAR(100) NOT NULL,
    content_type ENUM('markdown', 'video', 'interactive', 'quiz'),
    content_json LONGTEXT,
    sequence_order INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (feature_id) REFERENCES features(id) ON DELETE CASCADE
);

CREATE TABLE user_feature_progress (
    id TEXT PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    feature_id VARCHAR(100) NOT NULL,
    status ENUM('not_started', 'in_progress', 'completed'),
    progress_percentage INT DEFAULT 0,
    last_accessed_at TIMESTAMP,
    completion_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (feature_id) REFERENCES features(id),
    UNIQUE KEY unique_user_feature (user_id, feature_id)
);

CREATE INDEX idx_category ON features(category_id);
CREATE INDEX idx_user_feature ON user_feature_progress(user_id, feature_id);
```

### 2.2 Sample Data

```sql
INSERT INTO categories (id, name, icon_path, display_order) VALUES
('econ_101', 'Economics Basics', 'assets/icons/econ.png', 1),
('history_101', 'Historical Perspectives', 'assets/icons/history.png', 2),
('theory_101', 'Political Theory', 'assets/icons/theory.png', 3);

INSERT INTO features (id, title, description, category_id, difficulty_level, estimated_duration_minutes) VALUES
('feat_001', 'Marx\'s Theory of Labor', 'Deep dive into labor theory and value', 'theory_101', 'Intermediate', 45),
('feat_002', 'Historical Context', 'Understanding 19th century Europe', 'history_101', 'Beginner', 30);
```

---

## 3. Content Structure & JSON Formats

### 3.1 Feature Content Schema

```json
{
  "feature_id": "feat_001",
  "title": "Marx's Theory of Labor",
  "metadata": {
    "version": "1.0.0",
    "language": "en",
    "last_updated": "2024-01-15T10:30:00Z"
  },
  "sections": [
    {
      "id": "sec_001",
      "title": "Introduction to Labor Theory",
      "type": "markdown",
      "content": "# Labor Theory\n\nMarx's theory of labor examines the relationship between worker and capital...",
      "order": 1
    }
  ],
  "assessment": {
    "type": "quiz",
    "passing_score": 70
  }
}
```

---

## 4. Integration Points

### 4.1 System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   Flutter App (Client)                  │
├─────────────────────────────────────────────────────────┤
│  Presentation Layer (Screens, Widgets)                 │
│  ↓                                                       │
│  Business Logic Layer (BLoC, Providers)                │
│  ↓                                                       │
│  Repository Layer (Data Abstraction)                   │
└────────┬───────────────────────────────────┬────────────┘
         │                                   │
    ┌────▼────┐                        ┌────▼────────┐
    │ Firebase │                        │ REST API    │
    │ (Auth)   │                        │ (Features)  │
    └──────────┘                        └─────────────┘
```

### 4.2 API Endpoint Specifications

**Endpoint: GET /api/v1/features**
```
Query Parameters:
  - category: string (optional)
  - limit: int (default: 20)

Response (200 OK):
{
  "status": "success",
  "data": {
    "features": [...],
    "total_count": 245,
    "has_more": true
  }
}
```

---

## 5. Implementation Requirements

### 5.1 BLoC Pattern Implementation

```dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final FeatureRepository featureRepository;
  
  FeatureBloc({required this.featureRepository}) : super(FeaturesInitial()) {
    on<FetchFeaturesEvent>(_onFetchFeatures);
  }

  Future<void> _onFetchFeatures(
    FetchFeaturesEvent event,
    Emitter<FeatureState> emit,
  ) async {
    emit(FeaturesLoading());
    try {
      final features = await featureRepository.getFeatures();
      emit(FeaturesLoaded(features));
    } catch (e) {
      emit(FeaturesError(e.toString()));
    }
  }
}
```

---

## 6. Performance & Accessibility

### 6.1 Performance Optimization

- Implement pagination for feature lists (20 items per page)
- Use `cached_network_image` package for image caching
- Lazy load feature content sections

### 6.2 Accessibility Features (WCAG 2.1 Level AA)

- All interactive elements have semantic labels
- Minimum 4.5:1 color contrast for normal text
- Full keyboard navigation support
- Screen reader compatibility

---

## Version History
- v1.0.0 (2024-01-15): Initial specification
