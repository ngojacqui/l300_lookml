/**
 * @title Halloween Executive Board
 * @description Spooky eCommerce Executive Dashboard tracking sales and orders.
 * @created 2026-10-07T17:03:25-04:00
 */
import { DataApp, html, nothing, formatValue } from '/runtime/data-app.js';

export const elementName = 'halloween-dashboard';

export class HalloweenDashboard extends DataApp {
  static properties = {
    selectedDepartment: { type: String },
    chartType1: { type: String },
    chartType2: { type: String },
    activeTab: { type: String }
  };

  constructor() {
    super();
    this.lookerModel = 'thelook_ecommerce';
    this.explore = 'order_items';
    this.selectedDepartment = 'All';
    this.chartType1 = 'column';
    this.chartType2 = 'donut';
    this.activeTab = 'overview';
  }

  getEffectiveFilters(local = {}, { isTimeSeries = false } = {}) {
    const filters = { ...(this.dashboardFilters || {}), ...(this.crossFilters || {}) };
    if (this.selectedDepartment !== 'All') {
      filters['products.department'] = this.selectedDepartment;
    }
    return { ...filters, ...local };
  }

  render() {
    return html`
      <style>
        .da-container {
          --app-bg: #120914;
          --app-card-bg: #221226;
          --app-text: #e8d5e8;
          --app-title: #ff8c00;
          --app-muted: #8b798c;
          --app-border: #4a2552;
          --app-primary: #ff5e00;
          --app-chart-1: #ff5e00;
          --app-chart-2: #ff00ff;
          --app-chart-3: #9d00ff;
          --app-chart-4: #00ffcc;
          background-color: var(--app-bg);
          color: var(--app-text);
          padding: 16px;
          min-height: 100vh;
          font-family: 'Courier New', Courier, monospace;
        }

        .header-title {
          font-size: 28px;
          font-weight: bold;
          text-align: center;
          color: #ff8c00;
          margin-bottom: 24px;
          text-shadow: 0 0 10px #ff5e00, 0 0 20px #ff0000;
          text-transform: uppercase;
          letter-spacing: 2px;
        }
        
        .tabs {
          display: flex;
          border-bottom: 2px solid var(--app-border);
          margin-bottom: 20px;
        }
        
        .tab {
          padding: 10px 24px;
          cursor: pointer;
          color: var(--app-muted);
          font-weight: bold;
          font-size: 16px;
          text-transform: uppercase;
        }
        
        .tab.active {
          color: var(--app-primary);
          border-bottom: 3px solid var(--app-primary);
        }

        .tab:hover:not(.active) {
          color: var(--app-text);
        }

        /* The container for charts with select */
        .chart-with-switcher {
          display: flex;
          flex-direction: column;
          height: 100%;
          background: var(--app-card-bg);
          border: 1px solid var(--app-border);
          border-radius: 16px;
          padding: 16px;
          box-shadow: 0 4px 15px rgba(255, 94, 0, 0.1);
        }

        .chart-switcher {
          margin-bottom: 12px;
          display: flex;
          justify-content: flex-end;
        }
        
        /* Dropdowns for dark theme */
        app-select {
          --select-bg: #3a1c40;
          --select-border: #ff8c00;
          --select-text: #ff8c00;
        }
      </style>
      <div class="da-container">
        <div class="header-title">🎃 Spooky eCommerce Performance 👻</div>
        
        <div class="tabs">
          <div class="tab ${this.activeTab === 'overview' ? 'active' : ''}" @click=${() => this.activeTab = 'overview'}>Overview</div>
          <div class="tab ${this.activeTab === 'demographics' ? 'active' : ''}" @click=${() => this.activeTab = 'demographics'}>Demographics</div>
        </div>
        
        <div class="da-filter-bar">
          <app-select
            label="Department"
            .value=${this.selectedDepartment}
            .options=${['All', 'Men', 'Women']}
            @change=${e => { this.selectedDepartment = e.detail.value; }}>
          </app-select>
        </div>

        ${this.activeTab === 'overview' ? html`
          <section class="da-kpi-grid">
            <app-kpi
              label="Total Revenue"
              sparkline
              format="usd"
              .query=${{ fields: ['order_items.created_month', 'order_items.total_sale_price'], sorts: ['order_items.created_month desc'], limit: '12' }}
              .filters=${this.getEffectiveFilters({ 'order_items.created_month': '12 months ago for 12 months' }, { isTimeSeries: true })}>
            </app-kpi>
            <app-kpi
              label="Order Count"
              sparkline
              format="int"
              .query=${{ fields: ['order_items.created_month', 'order_items.count'], sorts: ['order_items.created_month desc'], limit: '12' }}
              .filters=${this.getEffectiveFilters({ 'order_items.created_month': '12 months ago for 12 months' }, { isTimeSeries: true })}>
            </app-kpi>
          </section>

          <section class="da-grid-2">
            <div class="chart-with-switcher">
              <div class="chart-switcher">
                <app-select
                  label="Chart Type"
                  .value=${this.chartType1}
                  .options=${[{label: 'Column', value: 'column'}, {label: 'Bar', value: 'bar'}, {label: 'Line', value: 'line'}]}
                  @change=${e => { this.chartType1 = e.detail.value; }}>
                </app-select>
              </div>
              <app-chart
                bare
                type=${this.chartType1}
                title="Revenue by State"
                height="300px"
                cross-filter
                .query=${{ fields: ['users.state', 'order_items.total_sale_price'], sorts: ['order_items.total_sale_price desc'], limit: '10' }}
                .filters=${this.getEffectiveFilters()}>
              </app-chart>
            </div>

            <div class="chart-with-switcher">
              <div class="chart-switcher">
                <app-select
                  label="Chart Type"
                  .value=${this.chartType2}
                  .options=${[{label: 'Donut', value: 'donut'}, {label: 'Pie', value: 'pie'}, {label: 'Funnel', value: 'funnel'}]}
                  @change=${e => { this.chartType2 = e.detail.value; }}>
                </app-select>
              </div>
              <app-chart
                bare
                type=${this.chartType2}
                title="Orders by Department"
                height="300px"
                cross-filter
                .query=${{ fields: ['products.department', 'order_items.count'], sorts: ['order_items.count desc'] }}
                .filters=${this.getEffectiveFilters()}>
              </app-chart>
            </div>
          </section>

          <section class="da-grid-1" style="margin-top: 16px;">
            <app-grid
              title="Recent Spooky Orders"
              height="400px"
              .query=${{ fields: ['order_items.id', 'users.state', 'products.department', 'order_items.total_sale_price', 'order_items.created_month'], sorts: ['order_items.created_month desc'], limit: '50' }}
              .filters=${this.getEffectiveFilters()}>
            </app-grid>
          </section>
        ` : html`
          <section class="da-kpi-grid">
            <app-kpi
              label="Active States"
              query-field="users.state"
              .query=${{ fields: ['users.state'], limit: '500' }}
              .filters=${this.getEffectiveFilters()}
              .options=${{ asCount: true }}>
            </app-kpi>
            <app-kpi
              label="Avg Age"
              query-field="users.age"
              .query=${{ fields: ['users.age'], limit: '100' }}
              .filters=${this.getEffectiveFilters()}>
            </app-kpi>
          </section>

          <section class="da-grid-2">
            <!-- Using a treemap to approximate geographic distribution since native map might require specific Highmaps setup -->
            <app-chart
              type="treemap"
              title="Users by Country"
              height="400px"
              cross-filter
              .query=${{ fields: ['users.country', 'order_items.count'], sorts: ['order_items.count desc'], limit: '50' }}
              .filters=${this.getEffectiveFilters()}>
            </app-chart>

            <app-chart
              type="column"
              title="Orders by Age Tier"
              height="400px"
              cross-filter
              .query=${{ fields: ['users.age_tier', 'order_items.count'], sorts: ['users.age_tier asc'], limit: '20' }}
              .filters=${this.getEffectiveFilters()}>
            </app-chart>
          </section>
          
          <section class="da-grid-1" style="margin-top: 16px;">
            <app-chart
              type="bar"
              title="Top User Locations"
              height="400px"
              cross-filter
              .query=${{ fields: ['users.city', 'users.state', 'order_items.count'], sorts: ['order_items.count desc'], limit: '15' }}
              .filters=${this.getEffectiveFilters()}>
            </app-chart>
          </section>
        `}
      </div>
    `;
  }
}

if (!customElements.get(elementName)) {
  customElements.define(elementName, HalloweenDashboard);
}

export default HalloweenDashboard;

