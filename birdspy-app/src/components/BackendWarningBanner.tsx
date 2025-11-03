'use client';

interface BackendWarningBannerProps {
  message?: string;
}

export default function BackendWarningBanner({ message }: BackendWarningBannerProps) {
  return (
    <div className="w-full bg-yellow-50 dark:bg-yellow-900/20 border-b border-yellow-200 dark:border-yellow-800">
      <div className="max-w-7xl mx-auto px-4 py-3 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between flex-wrap">
          <div className="flex items-center flex-1">
            <span className="flex p-2 rounded-lg bg-yellow-100 dark:bg-yellow-800">
              <svg
                className="h-5 w-5 text-yellow-600 dark:text-yellow-300"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
                />
              </svg>
            </span>
            <div className="ml-3">
              <h3 className="text-sm font-medium text-yellow-800 dark:text-yellow-200">
                Backend Connection Issue
              </h3>
              <p className="mt-1 text-sm text-yellow-700 dark:text-yellow-300">
                {message || 'Cannot connect to the BirdNET analysis backend. Please ensure the backend service is running.'}
              </p>
              <p className="mt-1 text-xs text-yellow-600 dark:text-yellow-400">
                Try running: <code className="bg-yellow-100 dark:bg-yellow-800 px-1 py-0.5 rounded">docker-compose up backend</code>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
