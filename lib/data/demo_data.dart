import '../models/models.dart';

/// Provides all seed/demo data for the DocSphereAI prototype.
/// In a real application this would be replaced by API/database calls.
class DemoData {
  static DateTime _dt(String d) => DateTime.parse(d);

  static List<Doc> buildDocs() => [
        Doc(
          'Academic Transcript',
          'Academic',
          'University record',
          'Ready',
          _dt('2026-10-16'),
          text:
              'Northbridge University\nAcademic transcript\nProgram: MSc Data Science\nGraduation: 2025-06-12\nAward: Distinction\nCredits Completed: 180\nGPA: 3.92',
          summary: 'Official academic record for the MSc Data Science programme.',
          author: 'Northbridge University',
          favorite: true,
          pinned: true,
          id: 'd1',
        ),
        Doc(
          'Research Paper — Graph Retrieval',
          'Research',
          'Research paper',
          'Ready',
          _dt('2026-10-12'),
          text:
              'Graph-based retrieval for personal knowledge systems. Authors: A. Rahman and S. Lee. Published 2025-11-04.\nAbstract: Personal documents exhibit dense cross-references that tree hierarchies fail to capture.',
          summary:
              'A research paper about retrieval over connected knowledge graphs.',
          author: 'Journal of Applied Computing',
          id: 'd2',
        ),
        Doc(
          'University Certificate',
          'Academic',
          'Degree certificate',
          'Needs Review',
          _dt('2026-10-11'),
          text:
              'UNIVERSITY CERTIFICATE\nThis certifies that Avery Rahman has completed the degree of Master of Science.\nAwarded June 2025.',
          summary: 'Scanned certificate with a few low-confidence text fields.',
          author: 'Northbridge University',
          favorite: true,
          id: 'd3',
        ),
        Doc(
          'Passport',
          'Identity',
          'Travel document',
          'Ready',
          _dt('2026-09-28'),
          expiry: _dt('2027-04-18'),
          text:
              'Passport Document\nIssuing authority: Example Republic\nDocument No: P9842104\nExpiry date: 2027-04-18\nHolder: Avery Rahman\nNationality: Citizen',
          summary: 'Official travel identity document expiring in April 2027.',
          author: 'Example Republic',
          id: 'd4',
        ),
        Doc(
          'Utility Invoice',
          'Finance',
          'Utility bill',
          'Processing',
          _dt('2026-10-21'),
          summary: 'Text extraction and OCR analysis is currently in progress.',
          author: 'Harbor Utilities',
          id: 'd5',
        ),
        Doc(
          'Driving Licence',
          'Licence',
          'Driving licence',
          'Ready',
          _dt('2026-08-14'),
          expiry: _dt('2026-10-09'),
          text:
              'Driving Licence Card\nLicence No: DL-88319-X\nExpiry date: 2026-10-09\nCategories: A, B\nHolder: Avery Rahman',
          summary: 'Driving licence. Expiry date has recently passed.',
          author: 'Example Transport Office',
          id: 'd6',
        ),
        Doc(
          'Rental Agreement',
          'Legal',
          'Rental agreement',
          'Failed',
          _dt('2026-10-04'),
          expiry: _dt('2027-02-01'),
          summary:
              'The sample file could not be parsed. Retry or upload another file.',
          author: 'Willow Street Property Group',
          id: 'd7',
        ),
        Doc(
          'Invoice — Lab Equipment',
          'Finance',
          'Invoice',
          'Pending Index',
          _dt('2026-10-03'),
          text:
              'Tax Invoice #INV-2026-0912\nMeridian Lab Supply\nTotal: \$1,480.00\nPayment Status: Paid',
          summary: 'Details extracted; vector search indexing is queued.',
          author: 'Meridian Lab Supply',
          id: 'd8',
        ),
        Doc(
          'Conference Notes',
          'Research',
          'Notes',
          'Ready',
          _dt('2026-10-01'),
          text:
              'Notes from international workshop on personal RAG memory systems and vector storage architectures.',
          summary: 'Hidden from main library view for personal focus.',
          author: 'Avery Rahman',
          hidden: true,
          id: 'd9',
        ),
        Doc(
          'Old Membership Card',
          'Other',
          'Membership card',
          'Ready',
          _dt('2026-09-15'),
          text: 'Library & Recreation Society Membership Card. Valid through 2024.',
          summary:
              'In Deleted Documents. Can be restored or permanently removed.',
          author: 'Example Society',
          deleted: true,
          id: 'd10',
        ),
        Doc(
          'Project Outline',
          'Research',
          'Research notes',
          'Pending Sorting',
          _dt('2026-09-30'),
          text:
              'DocSphereAI Architecture Outline: Flutter desktop client, FastAPI gateway, OCR pipeline, and Qdrant vector store.',
          summary:
              'Automated AI categorization is queued for next background cycle.',
          author: 'Avery Rahman',
          id: 'd11',
        ),
        Doc(
          'Senior Software Engineer CV & Resume',
          'Career',
          'Curriculum Vitae',
          'Ready',
          _dt('2026-10-22'),
          text:
              'Avery Rahman — Senior Full Stack & AI Engineer\nSummary: 5+ years experience building distributed desktop and web applications, Flutter, Python, FastAPI, Vector Search and RAG architectures.\nExperience:\n- Lead Developer at TechSphere Solutions\n- Built intelligent document indexing systems with Qdrant vector database\nEducation: MSc Data Science (Distinction), Northbridge University\nSkills: Dart, Flutter, Python, FastAPI, Docker, Semantic Search, OCR.',
          summary:
              'Synced from Drive / Documents folder. Full professional resume with experience, technical skills, and credentials.',
          author: 'Avery Rahman',
          favorite: true,
          pinned: true,
          id: 'd12',
        ),
        Doc(
          'AI & Cloud Architecture Slides',
          'Presentations',
          'Slide Deck',
          'Ready',
          _dt('2026-10-21'),
          text:
              'Presentation Slide Deck: Cloud AI Architecture & Semantic Document Retrieval.\nSlide 1: Problem Statement — Finding files across thousands of drive docs.\nSlide 2: Solution — Embedding personal documents into semantic vector space.\nSlide 3: RAG Pipeline with Qdrant and FastAPI.\nSlide 4: Interactive Life Canvas Knowledge Graph.',
          summary:
              'Slide deck imported from synced Drive folder. Indexed by slide topics for semantic recall.',
          author: 'Avery Rahman',
          id: 'd13',
        ),
      ];

  static List<Goal> buildGoals(List<Doc> docs) => [
        Goal(
          'Apply for Research Fellowship',
          [
            GoalItem('Academic transcript', doc: docs[0]),
            GoalItem('Research proposal'),
            GoalItem('Reference letters'),
            GoalItem('Identity document', doc: docs[3]),
          ],
          description:
              'Prepare all credential documents for the academic fellowship application.',
        ),
        Goal(
          'Renew Driving Licence',
          [
            GoalItem('Current driving licence', doc: docs[5]),
            GoalItem('Identity document', doc: docs[3]),
            GoalItem('Proof of address'),
          ],
          description:
              'Gather renewal paperwork and updated address verification.',
        ),
      ];

  static List<DemoAccount> buildAccounts() => [
        DemoAccount(
          'Avery Rahman',
          'avery.rahman@example.test',
          'Active',
          DateTime.parse('2026-02-12'),
          'Today, 09:18',
        ),
        DemoAccount(
          'Jordan Lee',
          'jordan.lee@example.test',
          'Active',
          DateTime.parse('2026-04-07'),
          'Yesterday',
        ),
        DemoAccount(
          'Casey Morgan',
          'casey.morgan@example.test',
          'Suspended',
          DateTime.parse('2025-12-19'),
          'Oct 12',
        ),
      ];

  static List<DemoIssue> buildIssues() => [
        DemoIssue(
          'Text extraction timed out',
          'Processing error',
          'Text reading',
          'New',
          'Oct 21, 10:32',
          'A sample OCR operation exceeded its response window. No document content is attached to this operational record.',
        ),
        DemoIssue(
          'Search index temporarily unavailable',
          'Service availability',
          'Search',
          'In Progress',
          'Oct 20, 16:08',
          'Sample index connectivity issue. This report contains service metadata only.',
          note: 'Monitoring recovery.',
        ),
        DemoIssue(
          'Upload could not be completed',
          'Upload failure',
          'Upload',
          'Resolved',
          'Oct 18, 12:41',
          'A sample upload request failed before processing began.',
          note: 'Sample connectivity issue resolved.',
        ),
      ];
}
