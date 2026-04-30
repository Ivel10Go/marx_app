# Feature Learning Paths Specification

## Overview
Comprehensive specification for learning path functionality that allows users to progress through structured educational content with personalized recommendations and adaptive difficulty levels.

---

## 1. UI/UX Specifications

### 1.1 Learning Path Overview Screen

**Visual Hierarchy:**
```
┌────────────────────────────────────────┐
│ Learning Paths                    [X]  │
├────────────────────────────────────────┤
│ Your Progress                          │
│ ████░░░░░░ 45% Complete              │
├────────────────────────────────────────┤
│ Available Paths:                       │
│ ┌──────────────────────────────────┐  │
│ │ 📚 Beginner Marxist Theory       │  │
│ │ Level: Beginner | 8 modules      │  │
│ │ Time: ~4 hours | ⭐⭐⭐⭐⭐       │  │
│ │ [Start Path]                     │  │
│ └──────────────────────────────────┘  │
│ ┌──────────────────────────────────┐  │
│ │ 🎓 Advanced Political Economy    │  │
│ │ Level: Advanced | 12 modules     │  │
│ │ Time: ~8 hours | ⭐⭐⭐⭐        │  │
│ │ [Continue Path]                  │  │
│ └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

### 1.2 Module Progression Visualization

**Path Progress Timeline:**
```dart
CustomPaint(
  painter: PathProgressPainter(
    modules: learningPath.modules,
    currentModuleIndex: 3,
    completedModuleIndices: [0, 1, 2],
  ),
  size: Size(double.infinity, 120),
)
```

**Components:**
- Module cards with completion indicators
- Milestone badges for achievements
- Estimated time remaining display
- Recommendation pills (Next Best Step)

### 1.3 Color Coding

- **Completed:** #06D6A0 (Green)
- **In Progress:** #FF6B35 (Orange)
- **Locked:** #CCCCCC (Gray)
- **Recommended:** #1AC8ED (Cyan)

---

## 2. Database Schema

### 2.1 Learning Path Tables

```sql
CREATE TABLE learning_paths (
    id TEXT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    difficulty_level ENUM('Beginner', 'Intermediate', 'Advanced', 'Expert'),
    total_estimated_duration_minutes INT,
    learning_objectives TEXT,
    prerequisites TEXT,
    target_audience VARCHAR(255),
    icon_url VARCHAR(500),
    cover_image_url VARCHAR(500),
    is_active BOOLEAN DEFAULT true,
    version INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE path_modules (
    id TEXT PRIMARY KEY,
    learning_path_id TEXT NOT NULL,
    module_number INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    feature_id VARCHAR(100),
    estimated_duration_minutes INT,
    learning_objectives TEXT,
    prerequisites_module_ids TEXT,
    difficulty_adjustment DECIMAL(3,2) DEFAULT 1.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (learning_path_id) REFERENCES learning_paths(id) ON DELETE CASCADE,
    FOREIGN KEY (feature_id) REFERENCES features(id),
    UNIQUE KEY unique_path_module_number (learning_path_id, module_number)
);

CREATE TABLE user_learning_path_progress (
    id TEXT PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    learning_path_id TEXT NOT NULL,
    current_module_id TEXT,
    status ENUM('not_started', 'in_progress', 'paused', 'completed'),
    overall_progress_percentage INT DEFAULT 0,
    total_time_spent_minutes INT DEFAULT 0,
    started_at TIMESTAMP,
    last_accessed_at TIMESTAMP,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (learning_path_id) REFERENCES learning_paths(id),
    FOREIGN KEY (current_module_id) REFERENCES path_modules(id),
    UNIQUE KEY unique_user_path (user_id, learning_path_id)
);

CREATE TABLE user_module_progress (
    id TEXT PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    module_id TEXT NOT NULL,
    status ENUM('not_started', 'in_progress', 'completed'),
    progress_percentage INT DEFAULT 0,
    time_spent_minutes INT DEFAULT 0,
    attempts INT DEFAULT 0,
    quiz_score INT,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (module_id) REFERENCES path_modules(id),
    UNIQUE KEY unique_user_module (user_id, module_id)
);

CREATE TABLE path_recommendations (
    id TEXT PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    learning_path_id TEXT NOT NULL,
    recommendation_reason VARCHAR(255),
    match_score DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (learning_path_id) REFERENCES learning_paths(id),
    UNIQUE KEY unique_user_path_rec (user_id, learning_path_id)
);

CREATE INDEX idx_user_path_status ON user_learning_path_progress(user_id, status);
CREATE INDEX idx_module_path ON path_modules(learning_path_id);
CREATE INDEX idx_user_module_status ON user_module_progress(user_id, status);
CREATE INDEX idx_recommendations ON path_recommendations(user_id, match_score DESC);
```

---

## 3. Content Structure & JSON Formats

### 3.1 Learning Path Definition

```json
{
  "id": "path_beginner_marxism",
  "title": "Beginner Marxist Theory",
  "description": "A comprehensive introduction to Marxist thought",
  "difficulty_level": "Beginner",
  "total_estimated_duration_minutes": 240,
  "learning_objectives": [
    "Understand core Marxist concepts",
    "Analyze Marx's economic theories",
    "Apply Marxist perspective to current events"
  ],
  "prerequisites": [],
  "icon_url": "assets/icons/marxism.svg",
  "modules": [
    {
      "id": "mod_001",
      "module_number": 1,
      "title": "Introduction to Marx",
      "description": "Who was Karl Marx and why does he matter?",
      "feature_id": "feat_intro_marx",
      "estimated_duration_minutes": 30,
      "learning_objectives": [
        "Understand Marx's biographical context",
        "Recognize key time periods in his life"
      ],
      "prerequisites_module_ids": [],
      "difficulty_adjustment": 0.8
    },
    {
      "id": "mod_002",
      "module_number": 2,
      "title": "Historical Context",
      "description": "19th century Europe and industrial development",
      "feature_id": "feat_historical_context",
      "estimated_duration_minutes": 45,
      "learning_objectives": [
        "Analyze industrial revolution's impact",
        "Understand class divisions"
      ],
      "prerequisites_module_ids": ["mod_001"],
      "difficulty_adjustment": 1.0
    }
  ],
  "metadata": {
    "version": "1.0.0",
    "language": "en",
    "target_audience": "Students, curious learners",
    "created_date": "2024-01-01T00:00:00Z"
  }
}
```

### 3.2 User Progress State

```json
{
  "user_id": "user_123",
  "learning_path_id": "path_beginner_marxism",
  "current_module_id": "mod_002",
  "status": "in_progress",
  "overall_progress_percentage": 45,
  "modules_progress": [
    {
      "module_id": "mod_001",
      "status": "completed",
      "progress_percentage": 100,
      "quiz_score": 92,
      "completed_at": "2024-01-10T14:30:00Z"
    },
    {
      "module_id": "mod_002",
      "status": "in_progress",
      "progress_percentage": 60,
      "time_spent_minutes": 25,
      "last_accessed": "2024-01-15T09:00:00Z"
    }
  ],
  "recommendations": {
    "next_module": "mod_002",
    "reason": "Continue your progress",
    "estimated_time": 20
  }
}
```

---

## 4. Integration Points

### 4.1 Recommendation Engine

```dart
class PathRecommendationEngine {
  Future<List<LearningPath>> getRecommendedPaths(
    String userId,
    {int limit = 5}
  ) async {
    // Algorithm considers:
    // 1. User's current skill level
    // 2. Learning history
    // 3. Time availability
    // 4. Interest patterns
    // 5. Completion rates
    
    final userProfile = await _getUserProfile(userId);
    final paths = await _getAllPaths();
    
    final scored = paths.map((path) {
      final score = _calculatePathScore(userProfile, path);
      return MapEntry(path, score);
    }).toList();
    
    scored.sort((a, b) => b.value.compareTo(a.value));
    return scored.take(limit).map((e) => e.key).toList();
  }
  
  double _calculatePathScore(UserProfile profile, LearningPath path) {
    double score = 0.0;
    
    // Skill level match (0-30 points)
    final skillDiff = (profile.averageSkillLevel - path.difficulty).abs();
    score += max(0, 30 - (skillDiff * 10));
    
    // Interest match (0-30 points)
    score += _calculateInterestMatch(profile, path) * 30;
    
    // Time availability (0-25 points)
    if (profile.avgTimePerWeek >= path.timeRequirement) {
      score += 25;
    } else {
      score += (profile.avgTimePerWeek / path.timeRequirement) * 25;
    }
    
    // Prerequisite satisfaction (0-15 points)
    if (_arePrerequisitesMet(profile, path)) {
      score += 15;
    }
    
    return score;
  }
}
```

### 4.2 API Endpoints

**GET /api/v1/learning-paths**
```
Response:
{
  "status": "success",
  "data": {
    "paths": [
      {
        "id": "path_001",
        "title": "Beginner Marxist Theory",
        "difficulty": "Beginner",
        "modules_count": 8,
        "estimated_duration": 240,
        "rating": 4.7
      }
    ]
  }
}
```

**GET /api/v1/learning-paths/:id/progress**
```
Response:
{
  "status": "success",
  "data": {
    "path_id": "path_001",
    "user_progress": {
      "status": "in_progress",
      "progress_percentage": 45,
      "current_module": 2
    }
  }
}
```

**POST /api/v1/learning-paths/:id/enroll**
```
Request:
{
  "user_id": "user_123"
}

Response (201 Created):
{
  "status": "success",
  "data": {
    "enrollment": {
      "user_id": "user_123",
      "path_id": "path_001",
      "enrolled_at": "2024-01-15T10:00:00Z"
    }
  }
}
```

---

## 5. Implementation Requirements

### 5.1 BLoC Implementation

```dart
class LearningPathBloc extends Bloc<LearningPathEvent, LearningPathState> {
  final LearningPathRepository repository;
  
  LearningPathBloc({required this.repository}) : super(LearningPathInitial()) {
    on<FetchPathsEvent>(_onFetchPaths);
    on<EnrollPathEvent>(_onEnrollPath);
    on<UpdateModuleProgressEvent>(_onUpdateModuleProgress);
  }

  Future<void> _onFetchPaths(
    FetchPathsEvent event,
    Emitter<LearningPathState> emit,
  ) async {
    emit(LearningPathsLoading());
    try {
      final paths = await repository.getLearningPaths(
        difficulty: event.difficulty,
      );
      emit(LearningPathsLoaded(paths));
    } catch (e) {
      emit(LearningPathsError(e.toString()));
    }
  }

  Future<void> _onUpdateModuleProgress(
    UpdateModuleProgressEvent event,
    Emitter<LearningPathState> emit,
  ) async {
    try {
      await repository.updateModuleProgress(
        pathId: event.pathId,
        moduleId: event.moduleId,
        progressPercentage: event.progressPercentage,
      );
      emit(ModuleProgressUpdated(event.moduleId));
    } catch (e) {
      emit(LearningPathsError(e.toString()));
    }
  }
}
```

### 5.2 Data Models

```dart
class LearningPath {
  final String id;
  final String title;
  final String description;
  final DifficultyLevel difficulty;
  final int totalDurationMinutes;
  final List<String> learningObjectives;
  final List<PathModule> modules;
  final double userRating;

  LearningPath({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.totalDurationMinutes,
    required this.learningObjectives,
    required this.modules,
    this.userRating = 0.0,
  });

  double get completionPercentage =>
      (modules.where((m) => m.isCompleted).length / modules.length) * 100;
}

class PathModule {
  final String id;
  final int moduleNumber;
  final String title;
  final int durationMinutes;
  final List<String> learningObjectives;
  final String? quizId;
  bool isCompleted = false;
  int progressPercentage = 0;

  PathModule({
    required this.id,
    required this.moduleNumber,
    required this.title,
    required this.durationMinutes,
    required this.learningObjectives,
    this.quizId,
  });
}
```

---

## 6. Performance & Accessibility

### 6.1 Optimization Strategies

- **Path Prefetching:** Pre-load next module's content
- **Lazy Module Loading:** Load modules on-demand
- **Progress Caching:** Cache user progress locally
- **Bandwidth Management:** Adaptive video quality

### 6.2 Accessibility Features

- **Text Sizing:** Support for 200% text magnification
- **High Contrast:** WCAG AA compliant color schemes
- **Screen Reader:** Full semantic labeling of progress elements
- **Keyboard Navigation:** Tab through path modules

---

## Version History
- v1.0.0 (2024-01-15): Initial specification
