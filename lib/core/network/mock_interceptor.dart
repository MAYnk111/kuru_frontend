import 'package:dio/dio.dart';
import '../config/api_config.dart';

/// Provides genuine reference fixtures when preview/offline demo mode is explicitly enabled
class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!ApiConfig.enableDemoPreviewMode) {
      // In production / standard mode, do not intercept; make real API call
      return handler.next(options);
    }

    final path = options.path;

    if (path.endsWith(ApiConfig.jobs)) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _jobsData,
        ),
      );
    } else if (path.contains('/api/v1/jobs/')) {
      final jobId = path.split('/').last;
      final job = _jobsData.firstWhere(
        (j) => j['id'] == jobId,
        orElse: () => _jobsData.first,
      );
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: job,
        ),
      );
    } else if (path.endsWith(ApiConfig.careerTwin)) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _careerTwinData,
        ),
      );
    } else if (path.endsWith(ApiConfig.growthGoals)) {
      if (options.method == 'PATCH') {
        // Handle goal toggle
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {'success': true},
          ),
        );
      }
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _growthGoalsData,
        ),
      );
    } else if (path.endsWith(ApiConfig.growthRoadmap)) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _roadmapData,
        ),
      );
    } else if (path.endsWith(ApiConfig.growthResources)) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _resourcesData,
        ),
      );
    } else if (path.endsWith(ApiConfig.growthProjects)) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _projectsData,
        ),
      );
    } else if (path.endsWith(ApiConfig.applications)) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: _applicationsData,
        ),
      );
    }

    // Default fallback in preview mode
    handler.next(options);
  }

  // --- Reference Datasets matching the Visual Prompt ---

  static final List<Map<String, dynamic>> _jobsData = [
    {
      'id': 'job-zoho-1',
      'title': 'Software Engineering Intern',
      'company': 'Zoho Corporation',
      'company_logo': 'https://upload.wikimedia.org/wikipedia/commons/2/29/Zoho_Corporation_2023_logo.svg',
      'location': 'Bengaluru, Karnataka (On-site)',
      'work_arrangement': 'On-site',
      'employment_type': 'Internship',
      'duration': '3-6 months',
      'stipend': '₹40K-₹60K',
      'posted_at': 'Posted 2 days ago',
      'source': 'Naukri',
      'source_url': 'https://www.naukri.com/job-listings-software-engineering-intern-zoho',
      'match_score': 92,
      'is_top_match': true,
      'is_saved': false,
      'skills': ['Python', 'React', 'APIs', 'Data Structures', 'Linux', 'Git'],
      'extra_skills_count': 3,
      'ai_match_analysis': {
        'match_percentage': 92,
        'points': [
          '8/10 core skills match',
          'Role aligns with your career path',
          'Good for internship goals',
          'Based on real company requirements',
        ],
      },
      'key_skills': [
        'Python',
        'Data Structures',
        'Algorithms',
        'System Design',
        'REST APIs',
        'Git',
        'Linux',
        'Problem Solving',
        'CS Fundamentals',
      ],
      'skill_fits': [
        {'skill': 'Python', 'percentage': 90, 'matched': true},
        {'skill': 'Data Structures', 'percentage': 80, 'matched': true},
        {'skill': 'System Design', 'percentage': 60, 'matched': true},
        {'skill': 'Linux', 'percentage': 40, 'matched': false},
      ],
      'description': 'We are looking for ambitious Software Engineering Interns passionate about building scalable cloud products, REST APIs, and intuitive user interfaces. You will work alongside senior engineers on real-world production systems.',
      'requirements': [
        'Proficiency in Python or modern object-oriented languages.',
        'Strong grasp of Data Structures and Algorithms.',
        'Basic familiarity with web protocols, REST APIs, and databases.',
        'Eagerness to learn clean architectural design patterns.',
      ],
      'about_company': 'Zoho Corporation is a leading Indian multinational technology company providing comprehensive cloud-based business software and enterprise applications serving millions of users globally.',
    },
    {
      'id': 'job-swiggy-2',
      'title': 'Backend Developer Intern',
      'company': 'Swiggy',
      'company_logo': 'https://upload.wikimedia.org/wikipedia/en/thumb/1/12/Swiggy_logo.svg/1200px-Swiggy_logo.svg.png',
      'location': 'Bengaluru (Hybrid)',
      'work_arrangement': 'Hybrid',
      'employment_type': 'Internship',
      'duration': '6 months',
      'stipend': '₹50K-₹70K',
      'posted_at': 'Posted 3 days ago',
      'source': 'Naukri',
      'source_url': 'https://www.naukri.com/job-listings-backend-developer-intern-swiggy',
      'match_score': 85,
      'is_top_match': false,
      'is_saved': false,
      'skills': ['Python', 'SQL', 'System Design', 'FastAPI', 'Redis'],
      'extra_skills_count': 2,
      'ai_match_analysis': {
        'match_percentage': 85,
        'points': [
          '7/9 core skills match',
          'High match in Python and backend fundamentals',
          'Requires deeper caching and distributed queuing experience',
        ],
      },
      'key_skills': ['Python', 'SQL', 'System Design', 'FastAPI', 'Redis', 'Docker'],
      'skill_fits': [
        {'skill': 'Python', 'percentage': 90, 'matched': true},
        {'skill': 'SQL', 'percentage': 85, 'matched': true},
        {'skill': 'System Design', 'percentage': 60, 'matched': true},
      ],
      'description': 'Join Swiggys core logistics and order-dispatch engineering squad to design high-throughput microservices.',
      'requirements': ['Strong algorithmic thinking and SQL database knowledge.'],
      'about_company': 'Swiggy is Indias premier on-demand convenience platform.',
    },
    {
      'id': 'job-adobe-3',
      'title': 'AI/ML Intern',
      'company': 'Adobe',
      'company_logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Adobe_Corporate_Logo.png/1200px-Adobe_Corporate_Logo.png',
      'location': 'Bengaluru (Hybrid)',
      'work_arrangement': 'Hybrid',
      'employment_type': 'Internship',
      'duration': '6 months',
      'stipend': '₹75K-₹100K',
      'posted_at': 'Posted 5 days ago',
      'source': 'Naukri',
      'source_url': 'https://www.naukri.com/job-listings-aiml-intern-adobe',
      'match_score': 78,
      'is_top_match': false,
      'is_saved': false,
      'skills': ['Python', 'Machine Learning', 'LLMs', 'PyTorch', 'Vector DBs'],
      'extra_skills_count': 3,
      'ai_match_analysis': {
        'match_percentage': 78,
        'points': [
          'Strong Python foundation',
          'Good progress on neural network architectures',
          'Opportunity to develop fine-tuning and retrieval techniques',
        ],
      },
      'key_skills': ['Python', 'PyTorch', 'Machine Learning', 'LLMs', 'Transformers'],
      'skill_fits': [
        {'skill': 'Python', 'percentage': 90, 'matched': true},
        {'skill': 'Machine Learning', 'percentage': 75, 'matched': true},
        {'skill': 'LLMs', 'percentage': 65, 'matched': true},
      ],
      'description': 'Adobe Research is seeking AI/ML interns to invent the future of creative intelligence.',
      'requirements': ['Background in Machine Learning, Deep Learning, and generative models.'],
      'about_company': 'Adobe changes the world through digital experiences.',
    },
  ];

  static final Map<String, dynamic> _careerTwinData = {
    'readiness_score': 78,
    'demonstrated_skills_count': 12,
    'in_progress_count': 5,
    'to_develop_count': 7,
    'categories': [
      {'name': 'Problem Solving', 'icon': 'brain', 'level': 85},
      {'name': 'Programming', 'icon': 'code', 'level': 90},
      {'name': 'System Design', 'icon': 'layers', 'level': 65},
      {'name': 'Tools & Frameworks', 'icon': 'wrench', 'level': 80},
      {'name': 'Communication', 'icon': 'people', 'level': 75},
    ],
    'skills': [
      {
        'id': 'sk-python',
        'name': 'Python',
        'category': 'Programming',
        'assessment_status': 'Demonstrated',
        'score': 90,
        'repository': 'arjun/backend-microservice',
        'commit_sha': '8f2b31c',
        'analyzed_at': '2025-08-14 10:22 UTC',
        'evidence': 'Robust FastAPI controllers, Pydantic type safety, pytest coverage 88%.',
      },
      {
        'id': 'sk-react',
        'name': 'React',
        'category': 'Programming',
        'assessment_status': 'Demonstrated',
        'score': 82,
        'repository': 'arjun/portfolio-frontend',
        'commit_sha': '4a1d99e',
        'analyzed_at': '2025-08-12 16:40 UTC',
        'evidence': 'Modular component design, hooks, TypeScript state management.',
      },
      {
        'id': 'sk-fastapi',
        'name': 'FastAPI',
        'category': 'Tools & Frameworks',
        'assessment_status': 'Demonstrated',
        'score': 88,
        'repository': 'arjun/backend-microservice',
        'commit_sha': '8f2b31c',
        'analyzed_at': '2025-08-14 10:22 UTC',
        'evidence': 'Asynchronous routes, OpenAPI documentation, JWT authentication middleware.',
      },
      {
        'id': 'sk-ml',
        'name': 'Machine Learning',
        'category': 'Programming',
        'assessment_status': 'In Progress',
        'score': 70,
        'repository': 'arjun/nlp-classifier',
        'commit_sha': '1b0c78a',
        'analyzed_at': '2025-08-10 11:15 UTC',
        'evidence': 'Scikit-learn pipeline, text tokenization, initial transformer fine-tuning.',
      },
      {
        'id': 'sk-cloud',
        'name': 'Cloud',
        'category': 'Tools & Frameworks',
        'assessment_status': 'To Develop',
        'score': 55,
        'repository': 'arjun/backend-microservice',
        'commit_sha': '8f2b31c',
        'analyzed_at': '2025-08-14 10:22 UTC',
        'evidence': 'Basic Dockerfile present; needs Kubernetes and AWS ECS deployment evidence.',
      },
      {
        'id': 'sk-sysdesign',
        'name': 'System Design',
        'category': 'System Design',
        'assessment_status': 'In Progress',
        'score': 60,
        'repository': 'arjun/backend-microservice',
        'commit_sha': '8f2b31c',
        'analyzed_at': '2025-08-14 10:22 UTC',
        'evidence': 'Relational schema normalized; needs caching and message queue integration.',
      },
    ],
    'connected_repositories': [
      {
        'name': 'arjun/backend-microservice',
        'url': 'https://github.com/arjun/backend-microservice',
        'last_commit': '8f2b31c',
        'status': 'Analyzed',
        'analyzed_at': '14 Aug 2025',
      },
      {
        'name': 'arjun/portfolio-frontend',
        'url': 'https://github.com/arjun/portfolio-frontend',
        'last_commit': '4a1d99e',
        'status': 'Analyzed',
        'analyzed_at': '12 Aug 2025',
      },
      {
        'name': 'arjun/nlp-classifier',
        'url': 'https://github.com/arjun/nlp-classifier',
        'last_commit': '1b0c78a',
        'status': 'Analyzed',
        'analyzed_at': '10 Aug 2025',
      },
    ],
  };

  static final List<Map<String, dynamic>> _growthGoalsData = [
    {
      'id': 'goal-1',
      'title': 'Complete REST API mini project',
      'description': 'Build a CRUD API with FastAPI and add tests.',
      'skill': 'FastAPI',
      'effort': '2h',
      'priority': 'High',
      'is_completed': true,
      'recommendation_reason': 'Demonstrates end-to-end API design for backend internships.',
    },
    {
      'id': 'goal-2',
      'title': 'Solve 5 DSA problems',
      'description': 'Focus on Arrays and Hashing (LeetCode).',
      'skill': 'Problem Solving',
      'effort': '1.5h',
      'priority': 'High',
      'is_completed': false,
      'recommendation_reason': 'Required in technical screening rounds for 85% of target companies.',
    },
    {
      'id': 'goal-3',
      'title': 'Learn System Design basics',
      'description': 'Watch recommended video and make notes.',
      'skill': 'System Design',
      'effort': '1h',
      'priority': 'Medium',
      'is_completed': false,
      'recommendation_reason': 'Fills identified gap in caching and horizontal scaling.',
    },
    {
      'id': 'goal-4',
      'title': 'Update your GitHub README',
      'description': 'Add project demo, tech stack and setup steps.',
      'skill': 'Developer Tooling',
      'effort': '30m',
      'priority': 'Low',
      'is_completed': true,
      'recommendation_reason': 'Increases recruiter engagement on your connected repositories.',
    },
    {
      'id': 'goal-5',
      'title': 'Set up Docker containerization',
      'description': 'Write multi-stage Dockerfile and docker-compose.yml.',
      'skill': 'Cloud',
      'effort': '1.5h',
      'priority': 'Medium',
      'is_completed': false,
      'recommendation_reason': 'Prerequisite for cloud deployment milestone.',
    },
  ];

  static final Map<String, dynamic> _roadmapData = {
    'target_role': 'Full-Stack Software Engineer & AI Specialist',
    'completion_percentage': 48,
    'milestones': [
      {
        'id': 'm1',
        'title': 'Milestone 1: Core Python & Backend Architecture',
        'status': 'Completed',
        'progress': 100,
        'estimated_weeks': '3 weeks',
        'description': 'Master synchronous and asynchronous Python, data structures, and FastAPI architecture.',
        'skills': ['Python', 'FastAPI', 'Pytest', 'SQL'],
        'projects': [
          {
            'title': 'Distributed Task Worker',
            'objective': 'Build an asynchronous worker using Redis and Celery.',
            'status': 'Completed',
          }
        ],
      },
      {
        'id': 'm2',
        'title': 'Milestone 2: Scalable System Design & Databases',
        'status': 'In Progress',
        'progress': 55,
        'estimated_weeks': '4 weeks',
        'description': 'Deep dive into caching strategies, database normalization, indexing, and load balancing.',
        'skills': ['PostgreSQL', 'Redis', 'System Architecture', 'Kafka'],
        'projects': [
          {
            'title': 'Real-time Analytics Dashboard',
            'objective': 'Stream simulated events and aggregate metrics.',
            'status': 'In Progress',
          }
        ],
      },
      {
        'id': 'm3',
        'title': 'Milestone 3: Cloud Infrastructure & Containerization',
        'status': 'Pending',
        'progress': 15,
        'estimated_weeks': '3 weeks',
        'description': 'Containerize microservices with Docker, configure CI/CD pipelines, and deploy to AWS.',
        'skills': ['Docker', 'AWS ECS', 'GitHub Actions', 'Terraform'],
        'projects': [
          {
            'title': 'Production Deployment Pipeline',
            'objective': 'Automated test, build, and deploy pipeline with rollback capabilities.',
            'status': 'Pending',
          }
        ],
      },
    ],
  };

  static final List<Map<String, dynamic>> _resourcesData = [
    {
      'id': 'res-1',
      'title': 'FastAPI Official Documentation & Tutorial',
      'provider': 'FastAPI / Tiangolo',
      'type': 'Documentation',
      'url': 'https://fastapi.tiangolo.com/tutorial/',
      'topic': 'Backend Engineering',
      'skill': 'FastAPI',
      'saved': true,
      'estimated_read_time': '45 mins',
    },
    {
      'id': 'res-2',
      'title': 'System Design Primer',
      'provider': 'GitHub (donnemartin)',
      'type': 'Repository',
      'url': 'https://github.com/donnemartin/system-design-primer',
      'topic': 'System Architecture',
      'skill': 'System Design',
      'saved': true,
      'estimated_read_time': '3 hours',
    },
    {
      'id': 'res-3',
      'title': 'NeetCode 150 - Core Coding Interview Algorithms',
      'provider': 'NeetCode',
      'type': 'Practice Course',
      'url': 'https://neetcode.io/practice',
      'topic': 'Data Structures & Algorithms',
      'skill': 'Problem Solving',
      'saved': false,
      'estimated_read_time': 'Ongoing',
    },
    {
      'id': 'res-4',
      'title': 'PostgreSQL High Performance Indexing Guide',
      'provider': 'Use The Index, Luke!',
      'type': 'Technical Article',
      'url': 'https://use-the-index-luke.com/',
      'topic': 'Database Engineering',
      'skill': 'SQL',
      'saved': false,
      'estimated_read_time': '1.5 hours',
    },
  ];

  static final List<Map<String, dynamic>> _projectsData = [
    {
      'id': 'proj-1',
      'title': 'REST API Mini Project with FastAPI',
      'objective': 'Build a CRUD API with FastAPI, Pydantic V2 validation, SQLite/PostgreSQL, and full pytest coverage.',
      'reason': 'Recommended to bridge the gap in structured testing and asynchronous endpoint design.',
      'target_skills': ['FastAPI', 'Python', 'Testing'],
      'difficulty': 'Intermediate',
      'duration': '2-3 days',
      'reference_repo': 'https://github.com/tiangolo/full-stack-fastapi-template',
    },
    {
      'id': 'proj-2',
      'title': 'Rate Limiter & Cache Service with Redis',
      'objective': 'Implement a token-bucket rate limiter middleware with Redis backing and fallback.',
      'reason': 'Addresses System Design and distributed state management requirements in 68% of job listings.',
      'target_skills': ['System Design', 'Redis', 'Python'],
      'difficulty': 'Advanced',
      'duration': '4-5 days',
      'reference_repo': 'https://github.com/redis/redis-py',
    },
  ];

  static final Map<String, dynamic> _applicationsData = {
    'metrics': {
      'applied': 12,
      'in_review': 4,
      'interviews': 2,
      'shortlisted': 6,
    },
    'active_applications': [
      {
        'id': 'app-1',
        'role': 'Software Engineer Intern',
        'company': 'Microsoft',
        'company_logo': 'https://upload.wikimedia.org/wikipedia/commons/4/44/Microsoft_logo.svg',
        'applied_date': 'Applied on 12 Aug 2025',
        'status': 'In Review',
        'status_type': 'in_review',
        'listing_url': 'https://careers.microsoft.com',
        'resume_version': 'Resume_v3_Software_Intern.pdf',
      },
      {
        'id': 'app-2',
        'role': 'AI/ML Intern',
        'company': 'Google',
        'company_logo': 'https://upload.wikimedia.org/wikipedia/commons/2/2f/Google_2015_logo.svg',
        'applied_date': 'Applied on 10 Aug 2025',
        'status': 'Shortlisted',
        'status_type': 'shortlisted',
        'listing_url': 'https://careers.google.com',
        'resume_version': 'Resume_v3_ML_Specialist.pdf',
      },
      {
        'id': 'app-3',
        'role': 'Backend Developer',
        'company': 'Zomato',
        'company_logo': 'https://upload.wikimedia.org/wikipedia/commons/7/75/Zomato_logo.png',
        'applied_date': 'Applied on 8 Aug 2025',
        'status': 'Interview',
        'status_type': 'interview',
        'listing_url': 'https://www.zomato.com/careers',
        'resume_version': 'Resume_v2_Backend.pdf',
      },
      {
        'id': 'app-4',
        'role': 'SDE Intern',
        'company': 'Amazon',
        'company_logo': 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg',
        'applied_date': 'Applied on 5 Aug 2025',
        'status': 'Applied',
        'status_type': 'applied',
        'listing_url': 'https://www.amazon.jobs',
        'resume_version': 'Resume_v2_General.pdf',
      },
    ],
  };
}
