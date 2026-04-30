# Feature Gamification Specification

## Overview
Comprehensive specification for gamification features including points, badges, leaderboards, streaks, and reward systems to drive user engagement and motivation.

---

## 1. UI/UX Specifications

### 1.1 Gamification Dashboard

**Main Gamification Hub:**
```
┌────────────────────────────────────────┐
│ Level & Achievements              [>] │
├────────────────────────────────────────┤
│ Your Level: 12                         │
│ ███████░░░░░ 70% to Level 13          │
│                                        │
│ 🔥 Streak: 15 Days                    │
│ Total Points: 2,450                    │
├────────────────────────────────────────┤
│ Recent Badges                          │
│ 🏅 Quick Learner (3 days ago)         │
│ 🎯 Focus Master (5 days ago)          │
│ 🌟 50-Point Milestone (1 week ago)    │
├────────────────────────────────────────┤
│ [View All Achievements] [Leaderboard] │
└────────────────────────────────────────┘
```

### 1.2 Achievement Card Design

```dart
Card(
  elevation: 2.0,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF8C5A)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('🏅', style: TextStyle(fontSize: 40)),
                if (isUnlocked) Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            SizedBox(height: 12),
            Text(badge.name, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(badge.description, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    ],
  ),
)
```

### 1.3 Leaderboard Interface

```
┌────────────────────────────────────────┐
│ Weekly Leaderboard            [Filters]│
├────────────────────────────────────────┤
│ Rank  Name              Points  Trend  │
├────────────────────────────────────────┤
│ 🥇 1. Alex Chen         1,250   📈    │
│ 🥈 2. Jordan Smith      1,180   📊    │
│ 🥉 3. Sam Williams      1,150   📉    │
│    4. You                950   📈    │
│    5. Casey Johnson      925   📉    │
│    ...                                 │
│ [Show More] [Monthly] [All Time]     │
└────────────────────────────────────────┘
```

---

## 2. Database Schema

### 2.1 Gamification Tables

```sql
CREATE TABLE user_profiles (
    id TEXT PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL UNIQUE,
    current_level INT DEFAULT 1,
    total_points INT DEFAULT 0,
    total_experience_points INT DEFAULT 0,
    current_streak_days INT DEFAULT 0,
    longest_streak_days INT DEFAULT 0,
    last_activity_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE badges (
    id TEXT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    icon_url VARCHAR(500),
    unlock_criteria TEXT,
    rarity ENUM('Common', 'Uncommon', 'Rare', 'Epic', 'Legendary'),
    points_reward INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_badges (
    id TEXT PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    badge_id TEXT NOT NULL,
    unlocked_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (badge_id) REFERENCES badges(id),
    UNIQUE KEY unique_user_badge (user_id, badge_id)
);

CREATE TABLE point_transactions (
    id TEXT PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    points_amount INT NOT NULL,
    transaction_type ENUM('feature_completed', 'quiz_passed', 'streak_bonus', 'challenge_completed', 'badge_earned', 'daily_bonus', 'social_share'),
    related_feature_id VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (related_feature_id) REFERENCES features(id)
);

CREATE TABLE user_streaks (
    id TEXT PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL UNIQUE,
    current_streak INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    last_activity_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE leaderboard_entries (
    id TEXT PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    period ENUM('daily', 'weekly', 'monthly', 'all_time'),
    rank INT,
    points INT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE KEY unique_user_period (user_id, period)
);

CREATE TABLE challenges (
    id TEXT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    challenge_type ENUM('daily', 'weekly', 'seasonal', 'limited_time'),
    objective TEXT NOT NULL,
    points_reward INT,
    difficulty ENUM('Easy', 'Medium', 'Hard'),
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_challenges (
    id TEXT PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    challenge_id TEXT NOT NULL,
    progress INT DEFAULT 0,
    completed BOOLEAN DEFAULT false,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (challenge_id) REFERENCES challenges(id),
    UNIQUE KEY unique_user_challenge (user_id, challenge_id)
);

CREATE INDEX idx_user_points ON user_profiles(total_points DESC);
CREATE INDEX idx_user_level ON user_profiles(current_level);
CREATE INDEX idx_leaderboard ON leaderboard_entries(period, rank);
CREATE INDEX idx_active_challenges ON challenges(end_date) WHERE end_date > NOW();
```

---

## 3. Content Structure & JSON Formats

### 3.1 Achievement System Configuration

```json
{
  "gamification_config": {
    "point_system": {
      "feature_completion_base": 50,
      "quiz_perfect_score_bonus": 25,
      "streak_multiplier": 1.1,
      "daily_login_bonus": 10,
      "level_up_bonus": 100
    },
    "level_progression": {
      "base_points_for_next_level": 500,
      "level_multiplier": 1.2,
      "max_level": 100,
      "milestone_levels": [10, 25, 50, 75, 100]
    },
    "badges": [
      {
        "id": "first_feature",
        "name": "First Steps",
        "description": "Complete your first feature",
        "icon": "🌱",
        "rarity": "Common",
        "unlock_criteria": {
          "type": "feature_count",
          "target": 1
        }
      },
      {
        "id": "streak_champion",
        "name": "Streak Champion",
        "description": "Maintain a 30-day learning streak",
        "icon": "🔥",
        "rarity": "Legendary",
        "unlock_criteria": {
          "type": "streak_days",
          "target": 30
        }
      },
      {
        "id": "knowledge_master",
        "name": "Knowledge Master",
        "description": "Complete all advanced modules",
        "icon": "🧠",
        "rarity": "Epic",
        "unlock_criteria": {
          "type": "path_completion",
          "target": "advanced"
        }
      }
    ],
    "streaks": {
      "daily_reset_hour": 0,
      "timezone": "UTC",
      "streak_break_cooldown_hours": 24
    }
  }
}
```

### 3.2 Challenge Definition

```json
{
  "challenge": {
    "id": "challenge_jan_2024_week1",
    "title": "Theory Week Sprint",
    "description": "Complete 3 theory modules in one week",
    "challenge_type": "weekly",
    "start_date": "2024-01-15T00:00:00Z",
    "end_date": "2024-01-21T23:59:59Z",
    "objective": {
      "type": "module_completion",
      "category": "theory",
      "count": 3
    },
    "points_reward": 150,
    "difficulty": "Medium",
    "icon": "📚",
    "rewards": [
      {
        "type": "badge",
        "id": "theory_week_participant"
      },
      {
        "type": "points",
        "amount": 150
      }
    ]
  }
}
```

---

## 4. Integration Points

### 4.1 Point Calculation Engine

```dart
class GamificationEngine {
  Future<void> awardPointsForCompletion(
    String userId,
    String featureId,
    {int quizScore = 0}
  ) async {
    final basePoints = 50;
    var totalPoints = basePoints;
    
    // Streak multiplier
    final streak = await _getCurrentStreak(userId);
    if (streak > 0) {
      totalPoints = (totalPoints * (1 + (streak * 0.1))).toInt();
    }
    
    // Quiz bonus
    if (quizScore >= 90) {
      totalPoints += 25;
    } else if (quizScore >= 75) {
      totalPoints += 10;
    }
    
    // Award points
    await _addPointTransaction(
      userId,
      totalPoints,
      TransactionType.featureCompleted,
      featureId,
    );
    
    // Check for level up
    await _checkLevelUp(userId);
    
    // Check for badge unlocks
    await _checkBadgeUnlocks(userId);
    
    // Update leaderboard
    await _updateLeaderboards(userId);
  }
  
  Future<void> updateStreak(String userId) async {
    final lastActivity = await _getLastActivityDate(userId);
    final today = DateTime.now();
    
    if (lastActivity == null) {
      // First activity
      await _setStreak(userId, 1);
    } else {
      final daysDifference = today.difference(lastActivity).inDays;
      
      if (daysDifference == 1) {
        // Continue streak
        final currentStreak = await _getCurrentStreak(userId);
        await _setStreak(userId, currentStreak + 1);
      } else if (daysDifference > 1) {
        // Streak broken
        await _setStreak(userId, 1);
      }
      // Same day: no change to streak
    }
  }
}
```

### 4.2 API Endpoints

**GET /api/v1/gamification/user-profile**
```json
{
  "status": "success",
  "data": {
    "user_id": "user_123",
    "level": 12,
    "total_points": 2450,
    "current_streak": 15,
    "longest_streak": 45,
    "badges_count": 8,
    "leaderboard_rank": 4
  }
}
```

**GET /api/v1/leaderboard?period=weekly**
```json
{
  "status": "success",
  "data": {
    "period": "weekly",
    "entries": [
      {
        "rank": 1,
        "user_id": "user_456",
        "points": 1250,
        "username": "Alex Chen"
      }
    ]
  }
}
```

---

## 5. Implementation Requirements

### 5.1 Gamification Widget

```dart
class GamificationOverviewWidget extends StatelessWidget {
  final UserProfile userProfile;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Level and Progress
        LevelProgressCard(
          currentLevel: userProfile.currentLevel,
          nextLevelPoints: userProfile.pointsToNextLevel,
          totalPoints: userProfile.totalPoints,
        ),
        SizedBox(height: 16),
        
        // Streak Display
        if (userProfile.currentStreak > 0)
          StreakWidget(
            streakDays: userProfile.currentStreak,
            longestStreak: userProfile.longestStreak,
          ),
        SizedBox(height: 16),
        
        // Recent Badges
        RecentBadgesWidget(badges: userProfile.recentBadges),
      ],
    );
  }
}

class LevelProgressCard extends StatelessWidget {
  final int currentLevel;
  final int nextLevelPoints;
  final int totalPoints;
  
  @override
  Widget build(BuildContext context) {
    final progressPercentage = (totalPoints % nextLevelPoints) / nextLevelPoints;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Level $currentLevel', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            LinearProgressIndicator(value: progressPercentage),
            SizedBox(height: 8),
            Text('$nextLevelPoints points to Level ${currentLevel + 1}'),
          ],
        ),
      ),
    );
  }
}
```

---

## 6. Performance & Accessibility

### 6.1 Optimization

- **Cached Leaderboards:** Refresh every 5 minutes
- **Background Points Calculation:** Use isolates for heavy computation
- **Lazy Load Badges:** Load on-demand in detailed view

### 6.2 Accessibility

- **Color-Blind Friendly:** Use patterns and icons in addition to colors
- **Semantic Labels:** All gamification elements labeled for screen readers
- **High Contrast Badges:** Ensure 7:1 contrast ratio

---

## Version History
- v1.0.0 (2024-01-15): Initial specification
