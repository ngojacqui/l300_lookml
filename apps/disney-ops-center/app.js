/**
 * @title Disney Operations Center
 * @description Real-time analytics for Disney Streaming sessions and subscribers.
 * @created 2026-10-07T14:51:32-04:00
 */
import { DataApp, html, nothing, formatValue } from '/runtime/data-app.js';

export const elementName = 'disney-ops-center';

export class DisneyOpsCenter extends DataApp {
  static properties = {
    selectedBrand: { type: String },
    activeTab: { type: String },
  };

  constructor() {
    super();
    this.lookerModel = 'disney_streaming';
    this.explore = 'viewing_sessions';
    this.selectedBrand = 'All';
    this.activeTab = 'Overview';
    this.isDark = true;
  }

  getEffectiveFilters(local = {}, { isTimeSeries = false } = {}) {
    const filters = { ...(this.dashboardFilters || {}), ...(this.crossFilters || {}) };
    if (this.selectedBrand !== 'All') {
      filters['content_catalog.brand'] = this.selectedBrand;
    }
    return { ...filters, ...local };
  }

  getBrandIcon() {
    switch(this.selectedBrand) {
      case 'Disney': return '🐭'; // Mickey Mouse
      case 'Marvel': return '🦸'; // Superhero
      case 'Nat Geo': return '🌍'; // Earth
      case 'Pixar': return '💡'; // Lamp
      case 'Star Wars': return '🛸'; // Spaceship
      case 'All':
      default: return '✨';
    }
  }

  render() {
    return html`
      <style>
        .dark-theme {
          --app-bg: #040714; /* Disney+ dark blue */
          --app-card-bg: #1a1d29;
          --app-border: #31343e;
          --app-text: #f9f9f9;
          --app-muted: #cacaca;
          --app-primary: #0072d2; /* Disney+ blue button color */
          --app-chart-1: #0072d2; /* Blue */
          --app-chart-2: #845ef7; /* Purple */
          --app-chart-3: #20c997; /* Teal */
          --app-chart-4: #fcc419; /* Yellow */
        }
        
        .header-title {
          font-size: 28px;
          font-weight: 700;
          letter-spacing: 1px;
          color: var(--app-text);
          display: flex;
          align-items: center;
          gap: 12px;
          margin: 0;
        }

        .disney-icon {
          font-size: 32px;
        }

        app-kpi {
          --app-kpi-value-size: 36px;
        }

        .da-tabs {
          display: flex;
          gap: 8px;
          margin-bottom: 24px;
          border-bottom: 1px solid var(--app-border);
          padding-bottom: 12px;
        }

        .da-tab-btn {
          background: transparent;
          border: none;
          color: var(--app-muted);
          font-size: 16px;
          font-weight: 600;
          padding: 8px 16px;
          border-radius: 8px;
          cursor: pointer;
          transition: background 0.2s, color 0.2s;
        }

        .da-tab-btn:hover {
          color: var(--app-text);
          background: var(--app-card-bg);
        }

        .da-tab-btn.active {
          color: var(--app-text);
          background: var(--app-tabs-btn-active, #31343e);
        }
      </style>
      
      <div class="da-container ${this.isDark ? 'dark-theme' : ''}">
        <header class="da-header" style="justify-content: space-between; align-items: center; margin-bottom: 24px;">
          <div>
            <h1 class="header-title">
              <span class="disney-icon">${this.getBrandIcon()}</span>
              Disney Streaming Operations Center
            </h1>
            <p style="margin: 4px 0 0; font-size: 14px; color: var(--app-muted); font-weight: 500;">
              Global Session & Content Analytics
            </p>
          </div>
          <div style="display: flex; gap: 16px; align-items: center;">
            <app-select
              label="Brand Filter"
              .value=${this.selectedBrand}
              .options=${['All', 'Disney', 'Marvel', 'Nat Geo', 'Pixar', 'Star Wars']}
              @change=${e => { this.selectedBrand = e.detail.value; }}>
            </app-select>
            ${this.renderThemeToggle({ showLabel: false })}
          </div>
        </header>

        <div class="da-tabs">
          <button class="da-tab-btn ${this.activeTab === 'Overview' ? 'active' : ''}" 
                  @click=${() => this.activeTab = 'Overview'}>
            Overview
          </button>
          <button class="da-tab-btn ${this.activeTab === 'Demographics' ? 'active' : ''}" 
                  @click=${() => this.activeTab = 'Demographics'}>
            Subscriber Demographics
          </button>
        </div>

        ${this.activeTab === 'Overview' ? html`
          <section class="da-kpi-grid">
            <app-kpi
              label="Total Sessions"
              query-field="viewing_sessions.count"
              format="int"
              .filters=${this.getEffectiveFilters()}
            ></app-kpi>
            <app-kpi
              label="Total Watch Time (Mins)"
              query-field="viewing_sessions.total_duration_minutes"
              format="int"
              .filters=${this.getEffectiveFilters()}
            ></app-kpi>
            <app-kpi
              label="Avg Session (Mins)"
              query-field="viewing_sessions.average_duration_minutes"
              format="decimal1"
              .filters=${this.getEffectiveFilters()}
            ></app-kpi>
            <app-kpi
              label="Total Subscribers"
              query-field="subscribers.count"
              format="int"
              .filters=${this.getEffectiveFilters()}
            ></app-kpi>
          </section>

          <section class="da-grid-2">
            <app-chart
              type="areaspline"
              title="Sessions Over Time"
              height="320px"
              cross-filter
              .query=${{ 
                fields: ['viewing_sessions.session_start_month', 'viewing_sessions.count'], 
                sorts: ['viewing_sessions.session_start_month asc'],
                limit: '12'
              }}
              .filters=${this.getEffectiveFilters({}, { isTimeSeries: true })}>
            </app-chart>
            
            <app-chart
              type="donut"
              title="Views by Brand"
              height="320px"
              cross-filter
              .query=${{ 
                fields: ['content_catalog.brand', 'viewing_sessions.count'], 
                sorts: ['viewing_sessions.count desc']
              }}
              .filters=${this.getEffectiveFilters()}>
            </app-chart>
          </section>

          <section class="da-grid-1-2" style="margin-top: 24px;">
            <app-chart
              type="bar"
              title="Top Devices"
              height="400px"
              cross-filter
              .query=${{ 
                fields: ['viewing_sessions.device_type', 'viewing_sessions.count'], 
                sorts: ['viewing_sessions.count desc']
              }}
              .filters=${this.getEffectiveFilters()}
              .options=${{ xAxis: { reversed: true } }}>
            </app-chart>

            <app-grid
              title="Top Content Titles"
              height="400px"
              .query=${{ 
                fields: ['content_catalog.title', 'content_catalog.brand', 'viewing_sessions.count', 'viewing_sessions.total_duration_minutes'], 
                sorts: ['viewing_sessions.count desc'],
                limit: '50'
              }}
              .filters=${this.getEffectiveFilters()}>
            </app-grid>
          </section>
        ` : nothing}

        ${this.activeTab === 'Demographics' ? html`
          <section class="da-grid-2">
            <app-chart
              type="pie"
              title="Subscriber Status"
              height="320px"
              cross-filter
              .query=${{ 
                fields: ['subscribers.status', 'subscribers.count'], 
                sorts: ['subscribers.count desc']
              }}
              .filters=${this.getEffectiveFilters()}>
            </app-chart>

            <app-chart
              type="donut"
              title="Subscription Tier"
              height="320px"
              cross-filter
              .query=${{ 
                fields: ['subscribers.subscription_tier', 'subscribers.count'], 
                sorts: ['subscribers.count desc']
              }}
              .filters=${this.getEffectiveFilters()}>
            </app-chart>
          </section>

          <section class="da-grid-2" style="margin-top: 24px;">
            <app-chart
              type="bar"
              title="Top Countries"
              height="360px"
              cross-filter
              .query=${{ 
                fields: ['subscribers.country', 'subscribers.count'], 
                sorts: ['subscribers.count desc'],
                limit: '15'
              }}
              .filters=${this.getEffectiveFilters()}
              .options=${{ xAxis: { reversed: true } }}>
            </app-chart>

            <app-chart
              type="column"
              title="Signups by Year"
              height="360px"
              cross-filter
              .query=${{ 
                fields: ['subscribers.signup_year', 'subscribers.count'], 
                sorts: ['subscribers.signup_year asc']
              }}
              .filters=${this.getEffectiveFilters()}>
            </app-chart>
          </section>
        ` : nothing}
      </div>
    `;
  }
}

if (!customElements.get(elementName)) {
  customElements.define(elementName, DisneyOpsCenter);
}

export default DisneyOpsCenter;

